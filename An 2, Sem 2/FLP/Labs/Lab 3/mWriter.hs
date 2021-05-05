
--- Monada Writer

newtype WriterS a = Writer { runWriter :: (a, String) } 


instance  Monad WriterS where
  return va = Writer (va, "")
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)


instance  Applicative WriterS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance  Functor WriterS where              
  fmap f ma = pure f <*> ma     

tell :: String -> WriterS () 
tell log = Writer ((), log)

logIncrement :: Int -> WriterS Int
logIncrement x = do
                    tell ("increment:" ++ (show x) ++ "\n")
                    return (x + 1)

logIncrement2 :: Int -> WriterS Int
logIncrement2 x = do
                     y <- logIncrement x
                     logIncrement y

{-
*Main> runWriter $ logIncrement 5
(6,"increment:5\n")
*Main> runWriter $ logIncrement2 5
(7,"increment:5\nincrement:6\n")
-}

logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x 1 = logIncrement x
logIncrementN x n = do
                       y <- logIncrement x
                       logIncrementN y (n - 1)

{-
*Main> runWriter $ logIncrementN 5 4
(9,"increment:5\nincrement:6\nincrement:7\nincrement:8\n")
-}
{- de la Iancu:

logIncrement :: Int -> WriterS Int
logIncrement x = Writer (x + 1, ("increment:" ++ show(x) ++ "\n"))

logIncrement2 :: Int -> WriterS Int
logIncrement2 x = logIncrement x >>= logIncrement
   
                  
-}
