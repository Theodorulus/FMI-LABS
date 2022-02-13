import Data.Char

type Input = String
type Output = String

newtype MyIO a = MyIO { runMyIO :: Input -> ( a , Input , Output ) }

instance Monad MyIO where
    return x = MyIO ( \ input -> ( x , input , " " ))
    m >>= k = MyIO f 
        where f input = let ( x , inputx , outputx ) = runMyIO m input
                            ( y , inputy , outputy ) = runMyIO ( k x ) inputx 
                        in ( y , inputy , outputx ++ outputy )

instance Applicative MyIO where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)

instance Functor MyIO where
   fmap f ma = pure f <*> ma

myPutChar :: Char -> MyIO ( )
myPutChar c = MyIO (\input -> ((), input, [c]) )

myGetChar :: MyIO Char
myGetChar = MyIO (\( c : input ) -> (c, input, ""))

runIO :: MyIO ( ) ->String-> String
runIO command input = third (runMyIO command input)
    where third ( _ , _ , x ) = x

myPutStr :: String -> MyIO ( )
myPutStr = foldr (>>) (return ()) . map myPutChar

myPutStrLn :: String -> MyIO ( )
myPutStrLn s = myPutStr s >> myPutChar '\n'

myGetLine :: MyIO String
myGetLine = do
    x <- myGetChar
    if x == '\n' 
        then return []
    else do 
        xs <- myGetLine
        return (x:xs)