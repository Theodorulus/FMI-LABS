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
  
logIncrement x = do
                    tell ("increment: " ++ (show x) ++ "\n")
                    return (x+1)

logIncrement2 x = do
                    y <- logIncrement x
                    logIncrement y

logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x n = do
                      y <- logIncrement x 
                      if (n-1>0) then
                        logIncrementN y (n-1)
                      else
                        return (x+n)
--logIncrementN x 1 = logIncrement x
--logIncrementN x n = do
--                      y <- logIncrement x
--                      logIncrementN y (n-1)

