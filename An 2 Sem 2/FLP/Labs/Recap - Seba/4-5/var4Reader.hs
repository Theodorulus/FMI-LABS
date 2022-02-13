
newtype Reader env a = Reader { runReader :: env -> a }
type Environment = [(Name, Value)]

-- newtype EnvReader a = Reader { runEnvReader :: Environment -> a }

instance Monad (Reader env) where
   return a = Reader (\_ -> a)
   ma >>= k = Reader f
       where f env = let va = runReader ma env
                    in runReader (k va) env
 
 
instance Applicative (Reader env) where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)
 
instance Functor (Reader env) where
   fmap f ma = pure f <*> ma

  
type M a = Reader Environment a
showM :: Show a => M a -> String
showM ma = show $ runReader ma []

ask :: Reader r r
ask = Reader id 

local :: ( r -> r ) -> Reader r a -> Reader r a
local f ma = Reader $ ( \ r -> ( runReader ma) ( f r ) )


pgm = App
   (Lam " x " ( ( Var " x " ) :+: ( Var " x " ) ) )
   ( ( Con 10) :+: ( Con 11) )

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
          | Fail
          | Amb Term Term
  deriving (Show)

data Value = Num Integer
           | Fun (Value -> M Value)
           | Wrong
 
instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"
 show Wrong   = "<wrong>"


lookupM :: Name -> M Value
lookupM x = do
    env <- ask
    case lookup x env of
        Just v -> return v
        Nothing -> return Wrong
 
add :: Value -> Value -> M Value
add (Num i) (Num j) = return (Num (i+j))
add _ _ = return Wrong
 
apply :: Value -> Value -> M Value
apply (Fun k) v = k v
apply _ _ = return Wrong
 
interp :: Term -> M Value
interp (Con i) = return (Num i)
interp (Var x) = lookupM x
interp (t1 :+: t2) = do
   v1 <- interp t1
   v2 <- interp t2
   add v1 v2
interp (Lam x e) = do
    env <- ask
    return $ Fun $ \v -> local (const ((x,v):env)) (interp e)
interp (App t1 t2) = do
   f <- interp t1
   v <- interp t2
   apply f v
 
test :: Term -> String
test t = showM $ interp t
 
pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))
          
pgm11:: Term
pgm11 = App
          (((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))
 
pgm2:: Term
pgm2 = App
          (Lam "x" ((Var "x") :+: (Var "y")))  ((Con 10) :+:  (Con 11))
 
pgm13 :: Term
pgm13 = App (Lam "x" ((Var "x") :+: (Var "x"))) (Amb ((Con 10) :+: (Con 11)) (Con 2))
 
pgm14 :: Term
pgm14 = App (Lam "x" ((Var "x") :+: (Var "x"))) (Amb (Con 5) (Amb ((Con 10) :+: (Con 11)) (Con 2)))

