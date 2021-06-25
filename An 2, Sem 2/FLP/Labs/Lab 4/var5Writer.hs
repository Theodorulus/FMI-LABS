
--- Monada Writer

{-

newtype Writer log a = Writer { runWriter :: (a, log)}

instance Monoid log => Monad (Writer log) where -- fara Monoid: * No instance for (Monoid log) arising from a use of `mappend'
     return a = Writer (a, mempty)
     ma >>= k = let (r1, log1) = runWriter ma
                    (rfinal, log2) = runWriter (k r1)
                   in Writer (rfinal, log1 `mappend` log2)
-- merge ++ in loc de mappend?


             

instance Monoid log => Applicative (Writer log) where -- fara Monoid: * No instance for (Monoid log) arising from a use of `return'
   pure = return
   mf <*> ma = do
   f <- mf
   a <- ma
   return (f a)

instance Monoid log => Functor (Writer log) where -- fara Monoid: * No instance for (Monoid log) arising from a use of `<*>'
   fmap f ma = pure f <*> ma

-}

newtype StringWriter a = StringWriter { runStringWriter :: (a, String)}

instance (Show a) => Show (StringWriter a) where
  show (StringWriter y) = show y

instance Monad StringWriter where
  return a = StringWriter a
  ma >>= k = k (runStringWriter ma)

instance Applicative StringWriter where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor StringWriter where
  fmap f ma = pure f <*> ma

instance Show a=>Show (StringWriter a) where
    show  ma ="Output:" ++ s ++ "\nValue:" ++ show a
                        where (a,s)=runStringWriter ma

instance Monad (StringWriter) where 
     return a = StringWriter (a, "")
     ma >>= k = let (r1, log1) = runStringWriter ma
                    (rfinal, log2) = runStringWriter (k r1)
                   in StringWriter (rfinal, log1 ++ log2)


instance Applicative (StringWriter) where -- fara Monoid: * No instance for (Monoid log) arising from a use of `return'
   pure = return
   mf <*> ma = do
   f <- mf
   a <- ma
   return (f a)

instance Functor (StringWriter) where -- fara Monoid: * No instance for (Monoid log) arising from a use of `<*>'
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

lookupM :: Name -> Environment -> M Value
lookupM x env = case lookup x env of
      Just v -> return v
      Nothing -> return Wrong

add :: Value -> Value -> M Value
add (Num i) (Num j) = return $ Num (i + j)
add _ _ = return Wrong

apply :: Value -> Value -> M Value
apply (Fun k) v = k v
apply _ _ = return Wrong

interp :: Term -> Environment -> M Value
interp (Con i) env = return (Num i)
interp (Var x) env = lookupM x env
interp (t1 :+: t2) env = do
     v1 <- interp t1 env
     v2 <- interp t2 env
     add v1 v2
interp (Lam x e) env = return $ Fun (\v -> interp e ((x, v) : env))
interp (App t1 t2) env  = do
        f <- interp t1 env
        v <- interp t2 env
        apply f v


test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x"))) ((Con 10) :+:  (Con 11))
           --Fun (\x -> x + x)              interp ((Identity Num 10) :+: (Identity Num 11))
           --                                  v1 <- Num 10, v2 <- Num 11
           --                                  add v1 v2 = add (Num 10) (Num 11)
           --                                => return (Num (10 + 11)) => Identity Num 21


pgm11 = App
           (((Var "x") :+: (Var "x"))) ((Con 10) :+: (Con 11))

pgm2 :: Term
pgm2 = App
           (Lam "x" ((Var "x") :+: (Var "y"))) ((Con 10) :+: (Con 11))


{-

*Main> interp pgm []
Output:
Value:7
*Main> interp pgm1 []
Output:
Value:42
*Main> interp pgm2 []
Output:
Value:<wrong>
*Main> interp pgm2[("y", (Num 2))]
Output:
Value:23

-}

-- test pgm
-- test pgm1