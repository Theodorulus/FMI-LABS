-- data Either err a = Left err | Right a
-- instance Monad ( Either err ) where
--    return = Right
--    Right va >>= k = k va
--    err >>= _ = err --Left verr >>=_ = Left verr

showM :: Show a => M a -> String
showM ( Left s ) = " Error : " ++ s
showM ( Right a ) = " Success : " ++ show a

type M a = Either String a

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
    Nothing -> Left ( " unbound variable " ++ x )

add :: Value -> Value -> M Value
add (Num i ) (Num j ) = return $ Num $ i + j
add v1 v2 = Left $ " Expected numbers : " ++ show v1 ++ " , " ++ show v2
apply :: Value -> Value -> M Value
apply ( Fun k ) v = k v
apply v _ = Left $ " Expected function : " ++ show v


interp :: Term -> Environment -> M Value
interp (Con i) env = return (Num i)
interp (Var x) env = lookupM x env
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

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))
-- test pgm
-- test pgm1
pgm11:: Term
pgm11 = App
          (((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))

pgm2:: Term
pgm2 = App
          (Lam "x" ((Var "x") :+: (Var "y")))  ((Con 10) :+:  (Con 11))

--Main> test pgm2
--"<wrongMaybe>"
--Main> test pgm11
--"<wrongMaybe>"
--Main> test pgm1
--"42"
--Main> interp pgm1 []
--Just 42
--Main> interp pgm11 []
--Nothing
--Main> interp pgm2 []
--Nothing
--Main> interp pgm2 [("y", (Num 2))]
--Just 23
--Main> test pgm1
--"42"

