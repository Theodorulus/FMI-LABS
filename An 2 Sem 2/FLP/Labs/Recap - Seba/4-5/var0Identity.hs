--- Monada Identity

newtype Identity a = Identity { runIdentity :: a }

instance (Show a) => Show (Identity a) where
   --show x = show (runIdentity x)
   show (Identity y) = show y

--- Limbajul si  Interpretorul
type M = Identity

instance Monad Identity where
   return a = Identity a
   ma >>= k = k (runIdentity ma) --runIdentity ca sa ne intoarca valoarea

instance Applicative Identity where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)

instance Functor Identity where
   fmap f ma = pure f <*> ma


showM :: Show a => M a -> String
showM = show . runIdentity

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

lookupM :: Name -> Environment -> M Value
lookupM x env = case lookup x env of
   Just v -> return v
   Nothing -> return Wrong

add :: Value -> Value -> M Value
add (Num v1) (Num v2) = return (Num (v1 + v2))
add _ _ = return Wrong

apply :: Value -> Value -> M Value
apply (Fun k) v = k v
apply _ _ = return Wrong

interp :: Term -> Environment -> M Value
interp (Var name) env = lookupM name env
interp (Con i) _ = return (Num i)
interp (t1 :+: t2) env = do
                           v1 <- interp t1 env
                           v2 <- interp t2 env
                           add v1 v2
interp (Lam x e) env = return (Fun (\v -> interp e ((x, v) : env)))
interp (App t1 t2) env = do
   f <- interp t1 env
   v <- interp t2 env
   apply f v


test :: Term -> String
test t = showM $ interp t []


-- test :: Term -> String
-- test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
-- test pgm
-- test pgm1
