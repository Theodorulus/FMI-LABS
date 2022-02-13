data EitherState state a = EitherState { runEitherState :: state -> Either state a}
instance Monad ( EitherState state ) where
   return va = EitherState (\s -> Right va)
   va >>= k = EitherState $ \s -> let
       Either va = runEitherState va s
       in 
        runEitherState (k va) news

-- newtype State state a = State { runState :: state -> ( a , state ) }

--instance Monad (State state) where 
--    return va = State ( \ s -> ( va , s ) )
--    ma >>= k = State $ \ s -> let
--        ( va , news ) = runState ma s
--        in
--        runState ( k va ) news
--
-- data Either err a = Left err | Right a
-- instance Monad ( Either err ) where
--    return = Right
--    Right va >>= k = k va
--    err >>= _ = err --Left verr >>=_ = Left verr

instance Applicative (EitherState state) where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)


instance Functor (EitherState state) where
   fmap f ma = pure f <*> ma

---- instance Show a => Show (State state a) where
----   show state =
----       let (value, steps) = runState state 0
----       in "Value: " ++ show value ++ "; Count: " ++ show steps
--
--get :: State state state
--get = State ( \ s -> ( s , s ) )
--
--set :: state -> State state ()
--set s = State ( const( ( ) , s ) )
--
--modify :: ( state -> state ) -> State state ( )
--modify f = State ( \ s -> ( ( ) , f s ) )


----- Limbajul si  Interpretorul
--
--type M a = Either String a
--
--showM :: Show a => M a -> String
--showM (Right a) = " Success: " ++ show a
--showM (Left a) = "Error: " ++ a
--
--type Name = String
--
--data Term = Var Name
--          | Con Integer
--          | Term :+: Term
--          | Lam Name Term
--          | App Term Term
--  deriving (Show)
--
--pgm :: Term
--pgm = App
--  (Lam "y"
--    (App
--      (App
--        (Lam "f"
--          (Lam "y"
--            (App (Var "f") (Var "y"))
--          )
--        )
--        (Lam "x"
--          (Var "x" :+: Var "y")
--        )
--      )
--      (Con 3)
--    )
--  )
--  (Con 4)
--
--
--data Value = Num Integer
--           | Fun (Value -> M Value)
--
--instance Show Value where
-- show (Num x) = show x
-- show (Fun _) = "<function>"
--
--type Environment = [(Name, Value)]
--
--lookupM :: Name -> Environment -> M Value
--lookupM x env = case lookup x env of
--   Just v -> return v
--   Nothing -> Left( "unbound variable: " ++ x) 
--
--add :: Value -> Value -> M Value
--add (Num i) (Num j) = return (Num (i+j))
--add v1 v2 = Left (" should be numbers: " ++ show v1 ++ ", " ++ show v2) 
--
--apply :: Value -> Value -> M Value
--apply (Fun k) v = k v
--apply v _ = Left ( "should be function: " ++ show v)
----apply _ _ = Left ( " ERROR ")
--
--interp :: Term -> Environment -> M Value
--interp (Con i) env = return (Num i)
--interp (Var x) env = lookupM x env
--interp (t1 :+: t2) env = do
--   v1 <- interp t1 env
--   v2 <- interp t2 env
--   add v1 v2
--interp (Lam x e) env = return (Fun (\v -> interp e ((x, v) : env)))
--interp (App t1 t2) env = do
--   f <- interp t1 env
--   v <- interp t2 env
--   apply f v
--
--
--test :: Term -> String
--test t = showM $ interp t []
--
--pgm1:: Term
--pgm1 = App
--          (Lam "x" ((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))
--          -- Identity Fun ( \x -> x+x)              interp ( (Identity Num 10) :+: (Identity Num 11))
--          --                                     v1 <- Num 10 , v2 <- Num 11
--          --                                     add v1 v2 = add (Num 10) (Num 11)
--          --                                       => return ( Num (10+11) ) => Identity Num 21
--          --  f <- Fun (\x -> x + x) v<- (Num 21)
--          --  apply f v = apply ( Fun (\x -> x+x)) (Num 21) => Identity Num 42
--          -- 
--          --   show (Identity y) = show y
--          --   show Identity (Num 42) = show (Num 42)
--          --                           show (Num x) = show x
--          --                            show (Num 42) = show 42 = 42
--
--pgm11:: Term
--pgm11 = App
--          (((Var "x") :+: (Var "x")))  ((Con 10) :+:  (Con 11))
--
--pgm2:: Term
--pgm2 = App
--          (Lam "x" ((Var "x") :+: (Var "y")))  ((Con 10) :+:  (Con 11))
----Main> interp pgm1[]
----Right 42
----Main> interp pgm11 []
----Left "unbound variable: x"
----Main> test pgm11
----"Error: unbound variable: x"
----Main> test pgm2
----"Error: unbound variable: y"
----Main> interp pgm2 []
----Left "unbound variable: y"
----Main> test pgm2
----"Error: unbound variable: y"
----Main> interp pgm2 [("y", (Num 2))]
----Right 23
--