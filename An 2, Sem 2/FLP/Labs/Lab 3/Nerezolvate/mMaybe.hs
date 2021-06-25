{- 
Monada Maybe este definita in GHC.Base 

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

(<=<) :: (a -> Maybe b) -> (c -> Maybe a) -> c -> Maybe b
f <=< g = \ x -> g x >>= f
--(<=<) f g x = g x >>= f

asoc :: (Int -> Maybe Int) -> (Int -> Maybe Int) -> (Int -> Maybe Int) -> Int -> Bool
asoc f g h x = (h <=< (g <=< f) $ x) == ((h <=< g) <=< f $ x)

pos :: Int -> Bool
pos  x = if x >= 0 then True else False

foo :: Maybe Int ->  Maybe Bool 
foo  mx =  mx  >>= (\x -> Just (pos x))  

foodo :: Maybe Int ->  Maybe Bool 
foodo mx = do
  x <- mx
  Just (pos x)

addM :: Maybe Int -> Maybe Int -> Maybe Int  
addM mx my = do
  x <- mx
  y <- my
  Just (x + y)


addM2 :: Maybe Int -> Maybe Int -> Maybe Int  
addM2 (Just x) (Just y) = Just (x + y)
addM2 _ _ = Nothing

test :: Maybe Int -> Maybe Int -> Bool
test mx my = addM mx my == addM2 mx my

cartesianProduct xs ys = xs >>= ( \x -> ys >>= \y-> return (x,y))

cartesianProductdo xs ys = do
  x <- xs
  y <- ys
  Just (x, y)

testcart :: Maybe Int -> Maybe Int -> Bool
testcart xs ys = cartesianProduct xs ys == cartesianProductdo xs ys

prod f xs ys = [f x y | x <- xs, y<-ys]

proddo f xs ys = do
  x <- xs
  y <- ys
  Just (f x y)

myGetLine :: IO String
myGetLine = getChar >>= \x ->
  if x == '\n' then
    return []
  else
    myGetLine >>= \xs -> return (x:xs)


myGetLinedo :: IO String
myGetLinedo = do
  x <- getChar 
  if x == '\n' then return []
  else 
    do
      xs <- myGetLinedo
      return (x:xs)

prelNo noin = sqrt noin
ioNumber = do
  noin <- readLn :: IO Float
  putStrLn $ "Intrare\n" ++ (show noin)
  let noout = prelNo noin
  putStrLn $ "Iesire"
  print noout

ioNumberSec = (readLn :: IO Float) >>= (\noin -> (putStrLn $ "Intare\n" ++ (show noin)) >> (let noout = prelNo noin in (putStrLn $ "Iesire") >> print noout))