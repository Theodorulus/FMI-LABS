-- instance Monad (State state) where 
--     return va = State ( \ s -> ( va , s ) )
--     ma >>= k = State $ \ s -> let
--         ( va , news ) = runState ma s
--         in
--         runState ( k va ) news

-- instance  Monad WriterS where
--   return va = Writer (va, "")
--   ma >>= k = let (va, log1) = runWriter ma
--                  (vb, log2) = runWriter (k va)
--              in  Writer (vb, log1 ++ log2)


newtype WriterState state a = WriterState { runWriterState :: state -> (a, String, state) } 

instance Monad (WriterState state) where
  return va = WriterState (\s -> (va, "", s) )
  ma >>= k = WriterState $ \s -> let 
        (va, log1, news) = runWriterState ma s
        (vb, log2, news2) = runWriterState (k va) news
        in runWriterState (WriterState (\news2 -> (vb,log1 ++ log2,news2))) news2
      

instance  Applicative (WriterState state) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance  Functor (WriterState state) where              
  fmap f ma = pure f <*> ma     



tell :: String -> WriterState state () 
tell log = WriterState (\s -> ((), log,s))

get :: WriterState state state
get = WriterState ( \ s -> ( s , "", s ) )

set :: state -> WriterState state ()
set s = WriterState ( const( ( ) , "", s ) )

modify :: ( state -> state ) -> WriterState state ( )
modify f = WriterState ( \ s -> ( ( ) , "", f s ) )

---------------------------------

type M a = WriterState Integer a

showM :: Show a => M a -> String
showM ma = show a ++ "\n" ++ "State: " ++ show state
    where (a,s,state) = runWriterState ma 0

tickS :: WriterState Integer ()
tickS = modify (+1)

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
          | Out Term
  deriving (Show)

pgm :: Term
pgm = App
  (Lam "y"
    (App
      (App
        (Lam "f"
          (Lam "y"
            (App (Var "f") (Var "y"))
          )
        )
        (Lam "x"
          (Var "x" :+: Var "y")
        )
      )
      (Con 3)
    )
  )
  (Con 4)


data Value = Num Integer
           | Fun (Value -> M Value)
           | Wrong

instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"
 show Wrong   = "<wrong>"

type Environment = [(Name, Value)]

lookupM :: Name -> Environment -> M Value
lookupM x env = case lookup x env of
   Just v -> return v
   Nothing -> return Wrong

add :: Value -> Value -> M Value
add (Num i) (Num j) = tickS >> return (Num (i+j))
add _ _ = return Wrong

apply :: Value -> Value -> M Value
apply (Fun k) v = tickS >> k v
apply _ _ = return Wrong

interp :: Term -> Environment -> M Value
interp (Con i) env = return (Num i)
interp (Var x) env = lookupM x env
interp (t1 :+: t2) env = do
   v1 <- interp t1 env
   v2 <- interp t2 env
   add v1 v2
interp (Lam x e) env = return (Fun (\v -> interp e ((x, v) : env)))
interp (App t1 t2) env = do
   f <- interp t1 env
   v <- interp t2 env
   apply f v
interp (Out t) env = do
   v <- interp t env
   tell (show v ++ "; ") --Evaluarea lui Out u afiseaza valoarea lui u uramta de ; si intoarce acea valoare
   return v

test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))
          -- Identity Fun ( \x -> x+x)              interp ( (Identity Num 10) :+: (Identity Num 11))
          --                                     v1 <- Num 10 , v2 <- Num 11
          --                                     add v1 v2 = add (Num 10) (Num 11)
          --                                       => return ( Num (10+11) ) => Identity Num 21
          --  f <- Fun (\x -> x + x) v<- (Num 21)
          --  apply f v = apply ( Fun (\x -> x+x)) (Num 21) => Identity Num 42
          -- 
          --   show (Identity y) = show y
          --   show Identity (Num 42) = show (Num 42)
          --                           show (Num x) = show x
          --                            show (Num 42) = show 42 = 42

-- test pgm
-- test pgm1
pgm11:: Term
pgm11 = App
          (((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))

--Main> interp pgm11 []
--wrong>
--
pgm2:: Term
pgm2 = App
          (Lam "x" ((Var "x") :+: (Var "y")))  ((Con 10) :+:  (Con 11))

--Main> interp pgm2 []
--wrong>
--
--Main> interp pgm2 [("y", (Num 2))]
--23
--
--dacam comentam Show Identity, atunci interp pgm2 [] - da eroare pt ca Identity(sore deosebire de Maybe) nu are instanta implicita pt show


