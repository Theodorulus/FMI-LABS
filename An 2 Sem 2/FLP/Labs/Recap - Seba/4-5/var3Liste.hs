-- instance Monad [] where
--    return va = [va]
--    ma >>= k = [vb | va <- ma, vb <- k va]



type M a = [ a ]

showM :: Show a => M a -> String
showM = show


pgm = ( App (Lam " x " ( Var " x " :+: Var " x " ) )
      (Amb ( Con 1 ) ( Con 2 ) ) )


type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
          | Amb Term Term 
          | Fail
  deriving (Show)


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

interp Fail _ = []
interp (Amb t1 t2 ) env = interp t1 env ++ interp t2 env


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
