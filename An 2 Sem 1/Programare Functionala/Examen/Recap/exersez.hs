import Data.Char
import Data.List

f2a :: Char -> Bool
f2a c 
   | elem c "abcdefghijklmABCDEFGHIJKLM" = True
   | isAlpha c = False
   | otherwise = error "Nu este litera!"
{-
Verific daca litera data este in prima jumatate a alfabetului folosind functia elem, 
apoi verific daca e litera(va fi implicit in a doua jumatate a alfabetului) folosind functia isAlpha,
iar in cazul in care niciuna din aceste conditii nu e indeplinita arunc o eroare.
-}



f2b :: [Char] -> Bool
f2b str = length[c | c <- str, isAlpha c && f2a c == True] > length[c | c <- str, isAlpha c && f2a c == False]

{-
Formez doua liste, una doar cu literele din prima jumatate a alfabetului, iar cealalta cu literele din a doua jumatate
a alfabetului folosind descrieri de liste. La final compar cate elemente sunt in fiecare dintre aceste liste. 
-}

f2c :: [Char] -> Bool
f2c str = length (primaJum str) > length (aDouaJum str)



primaJum :: [Char] -> [Char]
primaJum [] = []
primaJum (h:t)
   | isAlpha h && f2a h == True = h : primaJum t
   | otherwise = primaJum t

aDouaJum :: [Char] -> [Char]
aDouaJum [] = []
aDouaJum (h:t)
   | isAlpha h && f2a h == False = h : aDouaJum t
   | otherwise = aDouaJum t

{-
Formez doua liste, una doar cu literele din prima jumatate a alfabetului, iar cealalta cu literele din a doua jumatate
a alfabetului folosind doua functii auxiliare. La final compar cate elemente sunt in fiecare dintre aceste liste. 
-}

f3a :: [Int] -> [Int]
f3a list = [x | (x,y) <- zip list (tail list), x == y]

{-
Formez o lista noua doar cu elementele egale cu elementul de la indexul urmator. 
Acest lucru in verific folosind functia zip.
-}

f3b :: [Int] -> [Int]
f3b [] = []
f3b (h:t)
   | length t > 0 && h == head t = h : f3b t
   | otherwise = f3b t

{-
Formez o lista noua doar cu elementele egale cu elementul de la indexul urmator. 
Acest lucru in verific folosind functia head pentru tail-ul listei curente. 
Conditia ca lungimea tail-ului sa fie mai mare decat 0 este pentru a nu primi eroare atunci cand
se ajunge la capatul listei, astefel neapelandu-se tail [].
-}

prop list = f3a list == f3b list

{-
Proprietatea trebuie sa returneze un bool care arata daca functiile f2a si f2b returneaza aceeasi valoare.
-}




--Lab 2
--L2.2

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec x y [] = []
inIntervalRec x y (h:t)
   | h >= x && h <= y = h : inIntervalRec x y t
   | otherwise = inIntervalRec x y t

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp x y list = [a | a <- list, a >= x && a <= y]

--L2.3

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (h:t)
   | h > 0 = 1 + pozitiveRec t
   | otherwise = pozitiveRec t

pozitiveComp :: [Int] -> Int
pozitiveComp list = length [x | x <- list, x > 0]

--L2.4

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec list = pozitiiImpareRecAux list 0
pozitiiImpareRecAux [] _ = []
pozitiiImpareRecAux (h:t) a
   | odd h = a : (pozitiiImpareRecAux t (a+1))
   | otherwise = pozitiiImpareRecAux t (a+1)

pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp list = [b | (a, b) <- zip list [0..], odd a]

--L2.6

discountRec :: [Float] -> [Float]
discountRec [] = []
discountRec (h:t)
   | (0.75 * h) < 200 = (0.75 * h) : discountRec t
   | otherwise = discountRec t

discountComp :: [Float] -> [Float]
discountComp list = [0.75 * x | x <- list, 0.75 * x < 200] 

--Lab 3
--L3.1

factori :: Int -> [Int]
factori n = [x | x <- [1..n], n `mod` x == 0]

prim :: Int -> Bool
prim n = length (factori n) == 2

numerePrime :: Int -> [Int]
numerePrime n = [x | x <- [2..n], prim x == True]

--L3.2

myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 (x1:l1) (x2:l2) (x3:l3) = (x1,x2,x3) : (myzip3 l1 l2 l3)
myzip3 _ _ _ = []

--L3.3 MAP

firstEl :: [(a,b)] -> [a]
firstEl list = map fst list

sumList :: [[Int]] -> [Int]
sumList list = map sum list

prel2 :: [Integer] -> [Integer]
prel2 list = map faux list

faux :: Integer -> Integer
faux x
   | even x = x `div` 2
   | otherwise = x * 2

--L3.4

funct1 :: Char -> [String] -> [String]
funct1 c list = filter (elem c) list

funct2 :: [Int] -> [Int]
funct2 list = map (^2) (filter odd list)

funct3 :: [Int] -> [Int]
funct3 list = map (\(x,i) -> x^2) (filter (\(x,i) -> odd i) (zip list [0..]))

--funct4 :: [String] -> [String]
funct4 list = map (\x -> filter (\c -> c `elem` "AaEeIiOoUu") x) list

vocala :: Char -> Bool
vocala c
   | elem c "aeiouAEIOU" = True
   | otherwise = False

--mat supl

ordonataNat :: [Int] -> Bool
ordonataNat list = and [ x <= y | (x, y) <- zip list (tail list)]

ordonataNat1 :: [Int] -> Bool
ordonataNat1 [] = True
ordonataNat1 [x] = True
ordonataNat1 (x:xs)
   | x <= head xs = True && ordonataNat1 xs
   | otherwise = False



ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata list f = and [f x y | (x, y) <- zip list (tail list)]

--Lab 4
--1

produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (h:t) = h * (produsRec t)

produsFold :: [Integer] -> Integer
produsFold list = foldr (*) 1 list

andFold :: [Bool] -> Bool
andFold list = foldr (&&) True list

concatFold :: [[a]] -> [a]
concatFold list = foldr (++) [] list

rmChar :: Char -> String -> String
rmChar c str = [x | x <- str, x /= c]

rmCharsRec :: String -> String -> String
rmCharsRec [] str = str
rmCharsRec (h1:t1) str = rmCharsRec t1 (rmChar h1 str) 

test_rmchars :: Bool
test_rmchars = rmCharsRec ['a'..'l'] "fotbal" == "ot"

rmCharsFold :: String -> String -> String
rmCharsFold str1 str2= foldr (rmChar) str2 str1

--Lab 5

semn :: [Integer] -> String
semn [] = []
semn (h:t)
   | h >= -9 && h < 0 = '-' : semn t
   | h > 0 && h <= 9 = '+' : semn t
   | h == 0 = '0' : semn t
   | otherwise = semn t

semnFold :: [Integer] -> String
semnFold = foldr op unit
   where
      unit = []
      a `op` rest
         | a > 0 && a <= 9 = '+' : rest
         | a < 0 && a >= -9 = '-' : rest
         | a == 0 = '0' : rest
         | otherwise = rest


functieaux (a, b)
   | a `mod` 3 == 0 && b `mod` 3 == 0 = a - b
   | otherwise = a * b

functie list = foldr (+) 0 (map functieaux (zip list (tail list)))


palindrom :: [Int] -> Bool
palindrom [] = True
palindrom (h:t)
   | length t > 0 && h == (last t) = palindrom  (init t)
   | length t == 0 = True
   | otherwise = False


functien :: [a] -> a -> [a]
functien [] n = []
functien (h:t) n = [n, h] ++ (functien t n)


cartProd :: [a]->[b]->[(a,b)]
cartProd _ []=[]
cartProd [] _ = []
cartProd (x:xs) (y:ys) = [(x,y)] ++ cartProd [x] ys  ++ cartProd xs ys ++  cartProd xs [y] 






















