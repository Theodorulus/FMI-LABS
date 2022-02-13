-- Bibliografie:  Graham Hutton, Programming in Haskell, 2nd edition, Chapter 13

import Data.Char
import Control.Monad
import Control.Applicative




newtype Parser a =
    Parser { apply :: String -> [(a, String)] }
    
    
      
parse :: Parser a -> String -> a
parse m s = head [ x | (x,t) <- apply m s, t == "" ]


                    
-- Recunoasterea unui caracter arbitrar                                       
anychar :: Parser Char
anychar = Parser f
    where
    f []     = []
    f (c:s) = [(c,s)]
    
-- Recunoasterea unui caracter cu o proprietate
satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser f
    where
    f []                 = []
    f (c:s) | p c        = [(c, s)]
            | otherwise = []

-- Recunoasterea unui anumit caracter
char :: Char -> Parser Char
char c = satisfy (== c)     


-- Recunoasterea unui cuvant cheie caracter
string :: String -> Parser String
string [] = Parser (\s -> [([],s)])
string (x:xs) = Parser f  
 where
   f s = [(y:z,zs)| (y,ys)<- apply (char x) s, (z,zs) <- apply (string xs) ys]    
   
 -- *Main> apply (string "while") "while i>0 i++"
-- [("while"," i>0 i++")]
-- *Main> apply (string "while") "if t>5 then while i>0 i++ else stop"
-- []
-- *Main> apply (string "if") "if t>5 then while i>0 i++ else stop"
-- [("if"," t>5 then while i>0 i++ else stop")]
-- *Main> apply ((string "while") <|> (string "if")) "if t>5 then while i>0 i++ else stop"
-- [("if"," t>5 then while i>0 i++ else stop")]
-- *Main> apply ((string "while") <|> (string "if")) "while i>0 i++"
-- [("while"," i>0 i++")]

-- Exercitiul 1    

three :: Parser (Char, Char)
three = Parser f
        where f(a:b:c:t) = [((a,c),t)]
              f _ = []
              
-- *Main> apply three "aBc"
-- [(('a','c'),"")]
-- *Main> apply three "aBcd"
-- [(('a','c'),"d")]

three2 :: Parser (Char, Char)
three2 = Parser f
            where f s = [  ((a,c), t) | (a, l1) <- apply anychar s, (b, l2) <- apply anychar l1, (c, t)  <- apply anychar l2]
            
 -- *Main> apply three2 "aBcd"
-- [(('a','c'),"d")]
-- *Main> apply three2 "aBd"
-- [(('a','d'),"")]
-- *Main> apply three2 "ad"
-- []
         
-- Exercitiul 2

instance Monad Parser where
    return x  = Parser (\s -> [(x, s)])
    m >>= k   = Parser ( \s -> [   (vf, sf)| (v, t) <-apply m s, (vf, sf)  <-apply (k v) t ])
                     
                     
instance Applicative Parser where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor Parser where              
--   fmap f ma = pure f <*> ma 
      fmap f ma = Parser (\s -> [ (f v, t)  | (v, t) <-(apply ma s)] ) 

stringM :: String -> Parser String
stringM [] = return []
stringM (x:xs) = do
                      y<- char x
                      z<- string xs
                      return (y:z)
three2M :: Parser (Char, Char)
three2M = do
            a <- anychar
            b <- anychar
            c <- anychar
            return (a,c)
            
           
-- Exercitiul 3
--codul caracterului consumat --ord
anycharord = fmap ord anychar 
--      fmap f ma = Parser (\string -> [ (ord v, t)  | (v, t) <-(apply anychar string)] ) 

-- *Main> apply anycharord "abc"
-- [(97,"bc")]
-- *Main> apply anycharord "bc"
-- [(98,"c")]
-- *Main> apply anycharord "c"
-- [(99,"")]         
          
-- Exercitiul 4
                     
failM = Parser (\s ->[])

instance MonadPlus Parser where
    mzero      = failM  -- :: m a
    mplus m n  = Parser (\s -> apply m s ++ apply n s)

instance Alternative Parser where
  empty  = mzero
  (<|>) = mplus 


satisfyM :: (Char -> Bool) -> Parser Char
satisfyM p = do 
            c <- anychar
            if p c then return c else failM   
            
-- *Main> apply (satisfyM isUpper) "A"
-- [('A',"")]
-- *Main> apply (satisfyM isUpper) "Abcd"
-- [('A',"bcd")]
-- *Main> apply (satisfyM isUpper) "bcd"
-- []            
            
digit = satisfyM isDigit
abcP = satisfyM (`elem` ['A','B','C'])

-- *Main> apply(digit <|> abcP) "A12c"
-- [('A',"12c")]
-- *Main> apply(digit <|> abcP) "12c"
-- [('1',"2c")]
-- *Main> apply(digit <|> abcP) "a12c"
-- []

alt :: Parser a -> Parser a -> Parser a
alt p1 p2 = Parser f
          where f s = apply p1 s ++ apply p2 s 

-- *Main> apply(alt digit  abcP) "a12c"
-- []
-- *Main> apply(alt digit  abcP) "12c"
-- [('1',"2c")]
-- *Main> apply(alt digit  abcP) "A12c"
-- [('A',"12c")]          
 
manyP :: Parser a -> Parser [ a ]
manyP p = someP p <|> return [ ]
-- *Main> apply (many digit) "123abd"
-- [("123","abd"),("12","3abd"),("1","23abd"),("","123abd")]


someP :: Parser a -> Parser [ a ]
someP p = do 
          x <- p
          xs <- manyP p
          return ( x : xs )
          
-- *Main> apply (some digit) "123abd"
-- [("123","abd"),("12","3abd"),("1","23abd")]          


identifier :: Parser Char -> Parser Char -> Parser String
identifier firstCh nextCh = do 
                             c <- firstCh
                             s <- many nextCh
                             return ( c : s )
 
decimal :: Parser Int
decimal = do 
           s <- someP digit
           return ( read s )

negative :: Parser Int
negative = do     char '-'
                  n <- decimal
                  return (-n)
                  
integer :: Parser Int
integer = decimal `mplus` negative
  
skipSpace :: Parser ()
skipSpace = do 
              _ <- many ( satisfyM isSpace )
              return ()
              
tokenS :: Parser a -> Parser a
tokenS p = do 
           skipSpace
           x <- p
           skipSpace
           return x     

-- Exercitiul 5
howmany :: Char -> Parser Int
howmany c =  fmap length (someP (char c))     
-- *Main> apply (howmany 'a') "aaaaabcd"
-- [(5,"bcd"),(4,"abcd"),(3,"aabcd"),(2,"aaabcd"),(1,"aaaabcd")]
-- *Main> apply (howmany 'a') "bcdaaaa"
-- []

-- Exercitiul 6 
-- Definit, i un parser care consuma doua caractere si întoarce suma codurilor caracterelor consumate. Pentru s, iruri cu
-- mai put,in de doua caractere, întoarce lista vida.
twocharord = Parser f
        where f(a:b:t) = [(ord a + ord b, t)]
              f _ = []
 -- *Main> apply twocharord  "abc"
-- [(195,"c")]     
-- anycharord = fmap ord anychar 
-- --      fmap f ma = Parser (\string -> [ (ord v, t)  | (v, t) <-(apply anychar string)] ) 
twocharord2   = fmap (+) anycharord <*> anycharord 

-- *Main> apply twocharord2  "abc"
-- [(195,"c")]    
                    
                    
-- Exercitiul 7
no :: Int -> Int -> Int -> Int -> Int
no x y z v = x*1000+y*100+z*10 + v                  

fourdigit = undefined

 
