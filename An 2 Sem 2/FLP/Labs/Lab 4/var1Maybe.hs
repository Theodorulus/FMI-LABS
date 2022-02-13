--- Monada Maybe

{- Monada Maybe este definita in GHC.Base 

instance Monad Maybe where
  return = Just
  Just va  >>= k   = k va
  Nothing >>= _   = Nothing


instance Applicative Maybe where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)       

instance Functor Maybe where              
  fmap f ma = pure f <*> ma   
-}

--- Limbajul si  Interpretorul

type M a = Maybe a

showM :: Show a => M a -> String
showM (Just a) = show a
showM (Nothing) = "<wrongMaybe>"

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
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

instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"

type Environment = [(Name, Value)]

lookupM :: Name -> Environment -> M Value
lookupM x env = case lookup x env of
      Just v -> return v -- sau Just v
      Nothing -> Nothing -- modific

add :: Value -> Value -> M Value
add (Num i) (Num j) = return $ Num (i + j)
add _ _ = Nothing

apply :: Value -> Value -> M Value
apply (Fun k) v = k v
apply _ _ = Nothing

interp :: Term -> Environment -> M Value
interp (Con i) env = return (Num i)
interp (Var x) env = lookupM x env
interp (t1 :+: t2) env = do
     v1 <- interp t1 env
     v2 <- interp t2 env
     add v1 v2
interp (Lam x e) env = return $ Fun (\v -> interp e ((x, v) : env))
interp (App t1 t2) env  = do
        f <- interp t1 env
        v <- interp t2 env
        apply f v


test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x"))) ((Con 10) :+:  (Con 11))
           --Fun (\x -> x + x)              interp ((Identity Num 10) :+: (Identity Num 11))
           --                                  v1 <- Num 10, v2 <- Num 11
           --                                  add v1 v2 = add (Num 10) (Num 11)
           --                                => return (Num (10 + 11)) => Identity Num 21

pgm11 = App
           (((Var "x") :+: (Var "x"))) ((Con 10) :+: (Con 11))

pgm2 :: Term
pgm2 = App
           (Lam "x" ((Var "x") :+: (Var "y"))) ((Con 10) :+: (Con 11))



{-

*Main> test pgm1
  "42"
*Main> interp pgm1 []
  Just 42


*Main> test pgm11
  "<wrongMaybe>"
*Main> interp pgm11 []
  Nothing


*Main> test pgm2 
  "<wrongMaybe>"
*Main> interp pgm2 []
  Nothing
*Main> interp pgm2 [("y", (Num 2))] 
  Just 23

-}

-- test pgm
-- test pgm1
