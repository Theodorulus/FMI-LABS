--- Monada Maybe

type M a = Maybe a
showM :: Show a => M a -> String
showM ( Just a ) = show a
showM Nothing = " <wrong> "


--- Limbajul si  Interpretorul

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
   Nothing -> Nothing

add :: Value -> Value -> M Value
add (Num i ) (Num j ) = return (Num $ i + j )
add _ _ = Nothing

apply :: Value -> Value -> M Value
apply ( Fun k ) v = k v
apply _ _ = Nothing

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
          -- Identity Fun ( \x -> x+x)              interp ( (Identity Num 10) :+: (Identity Num 11))
          --                                     v1 <- Num 10 , v2 <- Num 11
          --                                     add v1 v2 = add (Num 10) (Num 11)
          --                                       => return ( Num (10+11) ) => Identity Num 21
          --  f <- Fun (\x -> x + x) v<- (Num 21)
          --  apply f v = apply ( Fun (\x -> x+x)) (Num 21) => Identity Num 42
          -- 
          --   show (Identity y) = show y
          --   show Identity (Num 42) = show (Num 42)
          --                           show (Num x) = show x
          --                            show (Num 42) = show 42 = 42

-- test pgm
-- test pgm1
pgm11:: Term
pgm11 = App
          (((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))

--Main> interp pgm11 []
--wrong>
--
pgm2:: Term
pgm2 = App
          (Lam "x" ((Var "x") :+: (Var "y")))  ((Con 10) :+:  (Con 11))

--Main> interp pgm2 []
--wrong>
--
--Main> interp pgm2 [("y", (Num 2))]
--23
--
--dacam comentam Show Identity, atunci interp pgm2 [] - da eroare pt ca Identity(sore deosebire de Maybe) nu are instanta implicita pt show

