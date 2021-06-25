--- Monada EnvReader
type Name = String

type Environment = [(Name, Value)]

newtype EnvReader a = Reader {runEnvReader :: Environment -> a}

instance (Show a) => Show (EnvReader a) where
  show ma = show $ runEnvReader ma []

instance Monad (EnvReader) where
  return a = Reader (\_ -> a)
  ma >>= k = Reader f
    where
      f env =
        let va = runEnvReader ma env
         in runEnvReader (k va) env

instance Applicative (EnvReader) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor (EnvReader) where
  fmap f ma = pure f <*> ma

ask :: EnvReader Environment
ask = Reader id

local :: (Environment -> Environment) -> EnvReader a -> EnvReader a
local f ma = Reader $ (\r -> (runEnvReader ma) (f r))

type M a = EnvReader a

showM :: Show a => M a -> String
showM ma = show $ runEnvReader ma []

--- Limbajul si  Interpretorul

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

interp :: Term -> M Value
interp (Var nume) = lookupM nume where
  lookupM nume = do
    env <- ask
    case lookup nume env of
      Just v -> return v
      Nothing -> return Wrong
interp (Con i) = return (Num i)
interp (t1 :+: t2) = do
  v1 <- interp t1
  v2 <- interp t2 
  add v1 v2 where
    add (Num v1) (Num v2) = return (Num (v1 + v2))
    add _ _ = return Wrong
interp (Lam nume exp) = do
  env <- ask
  return $ Fun $ \v -> local (const ((nume, v) : env)) (interp exp)
interp (App t1 t2) = do
  f <- interp t1
  v <- interp t2
  apply f v where
    apply (Fun k) v = k v
    apply _ _ = return Wrong

-- test :: Term -> String
-- test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
-- test pgm
-- test pgm1
