--- Monada Writer

newtype StringWriter a = StringWriter { runStringWriter :: (a, String)}

instance (Show a) => Show (StringWriter a) where
  show ma = "Output:" ++ s ++ "\nValue:" ++ show a
                        where (a,s)=runStringWriter ma

instance Monad StringWriter where
  return a = StringWriter (a, "")
  ma >>= k = let 
    (r1, log1) = runStringWriter ma 
    (rfinal, log2) = runStringWriter (k r1)
    in 
      StringWriter (rfinal, log1 ++ log2)

instance Applicative StringWriter where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor StringWriter where
  fmap f ma = pure f <*> ma

tell :: String -> StringWriter()
tell log = StringWriter ((), log)

--- Limbajul si  Interpretorul

type M a = StringWriter a

showM :: Show a => M a -> String
showM = show 

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
interp = undefined


-- test :: Term -> String
-- test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))
-- test pgm
-- test pgm1
