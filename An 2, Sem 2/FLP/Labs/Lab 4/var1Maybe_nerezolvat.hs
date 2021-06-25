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

type M = Maybe

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




interp :: Term -> Environment -> M Value
interp (Con i) env = return (Num i)
interp (Var name) env = lookupM name env where
  lookupM x env = case lookup x env of
    Just v -> return v
    Nothing -> Nothing
interp (t1 :+: t2) env = do
  v1 <- interp t1 env
  v2 <- interp t2 env
  add v1 v2 where
    add (Num v1) (Num v2) = return (Num (v1 + v2))
    add _ _ = Nothing
interp (Lam nume exp) env = return (Fun (\v -> interp exp ((nume, v):env)))
interp (App t1 t2) env = do
  f <- interp t1 env
  v <- interp t2 env
  apply f v where
    apply (Fun k) v = k v
    apply _ _ = Nothing




-- test :: Term -> String
-- test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
-- test pgm
-- test pgm1
