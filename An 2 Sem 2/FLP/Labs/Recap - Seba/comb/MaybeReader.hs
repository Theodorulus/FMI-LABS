--Maybe - Reader
--Monada Reader

--newtype Reader env a = Reader { runReader :: env -> a }

newtype MaybeReader env a = MaybeReader { runMaybeReader :: env -> Maybe a}
type Environment = [(Name, Value)]

instance Monad (MaybeReader env) where
  return x = MaybeReader (\_ -> Just x)
  ma >>= k = MaybeReader f
    where f env = case a of
                   Just a -> runMaybeReader (k a) env
                   Nothing -> Nothing
                  where a = runMaybeReader ma env

instance Applicative (MaybeReader env) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor (MaybeReader env) where
  fmap f ma = pure f <*> ma

--- Limbajul si  Interpretorul

type M a = MaybeReader Environment (Maybe a)


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
          (Var "x" :+: Var "z")
        )
      )
      (Con 3)
    )
  )
  (Con 4)


data Value = Num Integer
           | Fun (Value -> M Environment Value)
           | Wrong

instance Show Value where
 show (Num x) = show x
 show (Fun _) = "<function>"
 show Wrong   = "<wrong>"




ask :: MaybeReader (Maybe env) env
ask = MaybeReader id

local :: (env -> env) -> MaybeReader env a -> MaybeReader env a
local f ma = MaybeReader $ (\r -> (runMaybeReader ma)(f r))


lookupM :: Name -> M Value
lookupM x = do
    env <- Just ask
    case lookup x env1 of
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

