{- Monada Maybe este definita in GHC.Base 

instance Monad Maybe where
  return = Just
  Just va  >>= k   = k va
  Nothing >>= _   = Nothing


instance Applicative Maybe where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)       

instance Functor Maybe where              
  fmap f ma = pure f <*> ma   
-}

--import Test.QuickCheck

(<=<) :: (a -> Maybe b) -> (c -> Maybe a) -> c -> Maybe b
f <=< g = (\ x -> g x >>= f)

f1 :: String -> Maybe Int 
f1 x = if length x > 10 then Just $ length x else Nothing

g1 :: Int -> Maybe String 
g1 x = if x > 0 then Just $ concat $ replicate x "ab" else Nothing

f2, f3, f4 :: Int -> Maybe Int
f2 x = if x > 2 then Just (x * x) else Nothing 
f3 x = if x > 3 then Just (x + x) else Nothing
f4 x = if x > 50 then Just (x * x * x) else Nothing

asoc :: (Int -> Maybe Int) -> (Int -> Maybe Int) -> (Int -> Maybe Int) -> Int -> Bool
asoc f g h x = (h <=< (g <=< f) $ x) == ((h <=< g) <=< f $ x)

{-
*Main> f4 <=< (f3 <=< f2) $ 4
Nothing
*Main> (f4 <=< f2) <=< f3 $ 4
Just 262144

quickCheck $ asoc f3 f2 f4
+++ OK, passed 100 tests.
-}

pos :: Int -> Bool
pos  x = if (x >= 0) then True else False

foo :: Maybe Int ->  Maybe Bool 
foo  mx =  mx  >>= (\x -> Just (pos x))

{-
*Main> foo (Just $ 5)
Just True
*Main> foo (Just $ -5)
Just False
*Main> foo (Just (-5))
-}

foodo :: Maybe Int -> Maybe Bool 
foodo mx = do
    x <- mx --(Int <- Maybe Int)
    Just (pos x)

foodo1 :: Maybe Int -> Maybe Bool 
foodo1 mx = do
    x <- mx --(Int <- Maybe Int)
    return (pos x)
  
addM :: Maybe Int -> Maybe Int -> Maybe Int
addM Nothing _ = Nothing 
addM _ Nothing = Nothing
addM (Just x) (Just y) = Just (x + y)

addM2 :: Maybe Int -> Maybe Int -> Maybe Int  
addM2 mx my = do
                 x <- mx
                 y <- my
                 Just (x+y)

addM4 :: Maybe Int -> Maybe Int -> Maybe Int  
addM4 Nothing _ = Nothing
addM4 _ Nothing = Nothing
addM4 mx my = mx >>= (\x -> (my >>= (\y -> Just(x + y))))

testAdd :: Maybe Int -> Maybe Int -> Bool

testAdd mx my = (addM mx my) == (addM2 mx my) 

cartesian_product xs ys = xs >>= ( \x -> (ys >>= \y -> return (x, y)))
cartesian_productDO xs ys = do 
                               x <- xs
                               y <- ys
                               return (x, y)


prod f xs ys = [f x y | x <- xs, y <- ys]

prod_do f xs ys =
    do x <- xs
       y <- ys
       return (f x y)

{-
*Main> prod (+) [1,2] [3,4]
[4,5,5,6]
*Main> prod_do (\x y -> x + y) (Just 5) (Just 10)
Just 15
-}

 
myGetLine_do :: IO String
myGetLine_do =do 
               x <- getChar
               if x == '\n' then
                    return []
               else
                   do
                      xs <- myGetLine_do
                      return (x:xs)

prelNo noin = sqrt noin
ioNumber = do
   noin <- readLn :: IO Float
   putStrLn $ "Intrare\n" ++ (show noin)
   let noout = prelNo noin
   putStrLn $ "Iesire"
   print noout


ioNumber2=
    (readLn::IO Float) >>= (\noin -> (putStrLn $ ("Intrare\n" ++ (show noin))) >> (let noout = prelNo noin in (putStrLn $ "Iesire") >> print noout))

{-
*Main> ioNumber2
10
Intrare
10.0
Iesire
3.1622777
*Main> ioNumber2
9
Intrare
9.0
Iesire
3.0
-}

