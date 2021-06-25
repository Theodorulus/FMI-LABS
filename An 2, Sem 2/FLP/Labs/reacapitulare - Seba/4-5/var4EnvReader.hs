--- Monada Identity
 
newtype EnvReader a = Reader { runEnvReader :: Environment -> a }


instance Monad EnvReader where
   return a = Reader (\_ -> a)
   ma >>= k = Reader f
       where f env = let va = runEnvReader ma env
                    in runEnvReader (k va) env
 
 
instance Applicative EnvReader where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)
 
instance Functor EnvReader where
   fmap f ma = pure f <*> ma
 
ask :: EnvReader Environment
ask = Reader id
 
local :: (Environment -> Environment) -> EnvReader a -> EnvReader a
local f ma = Reader $ (\r -> (runEnvReader ma) (f r))
 
--- Limbajul si  Interpretorul
 
type M = EnvReader
 
showM :: Show a => M a -> String
showM ma = show $ runEnvReader ma []
 
type Name = String
 
data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
          | Fail
          | Amb Term Term
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

