--- Monada Identity

newtype Identity a = Identity { runIdentity :: a }

instance (Show a) => Show (Identity a) where
  show (Identity y) = show y

instance Monad Identity where
  return a = Identity a
  ma >>= k = k (runIdentity ma)

instance Applicative Identity where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor Identity where
  fmap f ma = pure f <*> ma


--- Limbajul si  Interpretorul

type M = Identity

showM :: Show a => M a -> String
showM = show .runIdentity

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
           | Wrong

instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"
 show Wrong   = "<wrong>"

type Environment = [(Name, Value)]

interp :: Term -> Environment -> M Value
interp (Var nume) env = lookupM nume env where
  lookupM x env = case lookup x env of
    Just v -> return v
    Nothing -> return Wrong
interp (Con i) env = return (Num i)
interp (t1 :+: t2) env = do
  v1 <- interp t1 env
  v2 <- interp t2 env
  add v1 v2 where
    add (Num v1) (Num v2) = return (Num (v1 + v2))
    add _ _ = return Wrong
interp (Lam nume exp) env = return (Fun (\v -> interp exp ((nume, v):env)))
interp (App t1 t2) env = do
  f <- interp t1 env
  v <- interp t2 env
  apply f v where
    apply (Fun k) v = k v
    apply _ _ = return Wrong


test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
-- test pgm
-- test pgm1
