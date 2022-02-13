import   Data.List

-- L3.1 Încercati sa gasiti valoarea expresiilor de mai jos si
-- verificati raspunsul gasit de voi în interpretor:
{-
[x^2 | x <- [1 .. 10], x `rem` 3 == 2]
[(x, y) | x <- [1 .. 5], y <- [x .. (x+2)]]
[(x, y) | x <- [1 .. 3], let k = x^2, y <- [1 .. k]]
[x | x <- "Facultatea de Matematica si Informatica", elem x ['A' .. 'Z']]
[[x .. y] | x <- [1 .. 5], y <- [1 .. 5], x < y ]

-}

factori :: Int -> [Int]
factori x = [y | y <-[1..x], x `rem` y == 0]

prim :: Int -> Bool
prim x 
   | length (factori x) == 2 = True
   | otherwise = False

numerePrime :: Int -> [Int]
numerePrime x = [y | y <- [2..x], prim y]

-- L3.2 Testati si sesizati diferenta:
-- [(x,y) | x <- [1..5], y <- [1..3]]
-- zip [1..5] [1..3]

myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
{-
myzip3 [] [] [] = []
myzip3 [_] [] [] = []
myzip3 [] [_] [] = []
myzip3 [] [] [_] = []
myzip3 [] [_] [_] = []
myzip3 [_] [] [_] = []
myzip3 [_] [_] [] = []
-}
{-
myzip3 [] _ _ = []
myzip3 _ [] _ = []
myzip3 _ _ [] = []
-}
myzip3 (x1:l1) (x2:l2) (x3:l3) = (x1,x2,x3) : (myzip3 l1 l2 l3)
myzip3 _ _ _ = []

myzip2 :: [Int] -> [Int] -> [(Int, Int)]
myzip2 [_] [] = []
myzip2 [] [_] = []
myzip2 (x:xs) (y:ys) = (x,y) : (myzip2 xs ys)

--------------------------------------------------------
----------FUNCTII DE NIVEL INALT -----------------------
--------------------------------------------------------

adunare :: Int -> Int
adunare x = x + 10

aplica2 :: (a -> a) -> a -> a
--aplica2 f x = f (f x)
--aplica2 f = f.f
--aplica2 f = \x -> f (f x)
aplica2  = \f x -> f (f x)

-- L3.3
{-

map (\ x -> 2 * x) [1 .. 10]
map (1 `elem` ) [[2, 3], [1, 2]]
map ( `elem` [2, 3] ) [1, 3, 4, 5]

*Main> map (*3) [1,2,3]
[3,6,9]
*Main> map adunare [1,2,3]
[11,12,13]
*Main> map ($ 3) [ ( 4 +) , (10 * ) , ( ^ 2) , sqrt ]
[7.0,30.0,9.0,1.7320508075688772]
*Main> map (\ x -> 2 * x ) [1..10]
[2,4,6,8,10,12,14,16,18,20]
*Main> map (1 `elem` ) [ [ 2 , 3 ] , [ 1 , 2 ] ]
[False,True]
*Main> map ( `elem` [ 2 , 3 ] ) [ 1 , 3 , 4 , 5 ]
[False,True,False,False]

-}

-- firstEl [ ('a', 3), ('b', 2), ('c', 1)]
firstEl l = map fst l

-- sumList [[1, 3],[2, 4, 5], [], [1, 3, 5, 6]]
sumList l = map sum l

-- prel2 [2,4,5,6]

parImpar :: Integer -> Integer
parImpar x
   | even x = x `div` 2
   | odd x = x * 2 

prel2 l= map parImpar l

-- L3.4
{-
*Main> filter odd [ 3 , 1 , 4 , 2 , 5 ]
[3,1,5]
-}
--1
funct1 :: Char -> [String] -> [String]
funct1 a list = filter (elem a) list

{-
*Main> funct 'a' ["abc", "cbd"]
["abc"]
-}

--2
funct2 :: [Integer] -> [Integer]
funct2 list = map (^2) (filter odd list)
{-
*Main> funct2 [1..5]
[1,9,25]
-}


--3
funct3 :: [Integer] -> [Integer]
--funct3 list = map (^2) [b | (a, b) <- zip [0..] list, odd a] 
funct3 list = map (\(x,y) -> x^2) (filter (\(x,i) -> odd i) (zip list [0..]))


--4
numaiVocale :: [String] -> [String]
numaiVocale list = map (\x -> filter (\c -> c `elem` "AaEeIiOoUu") x) list


-- L3.5
mymap f [] = []
mymap f (x:xs) = f x : mymap f xs


myfilter p (x:xs)
  |p x = x : myfilter p xs
  |otherwise = myfilter p xs
myfilter _ [] = []


myfilter2 p xs = [x | x <- xs, p x]


--MATERIAL SUPLIMENTAR

numerePrimeCiur :: Int -> [Int]
numerePrimeCiur x = auxCiur [2..x]
   where
   auxCiur [] = []
   auxCiur (h:xs) = h : auxCiur [x | x <- xs, x `mod` h > 0]

--1

ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x : xs) = and [x <= y | (x,y) <- zip (x:xs) xs]

--2


ordonataNat1 [] = True
ordonataNat1 (h:t)
   |length t == 0 = True
   |h <= head t && length t == 1 = True
   |h <= head t = ordonataNat1 t
   |otherwise = False


--3
--a

ordonata :: [a]−>(a−> a−> Bool)−> Bool
ordonata (h:t) f = and [f x y | (x,y) <- zip (h:t) t]

--b
--c

--(*<*) :: (Integer, Integer) −> (Integer, Integer ) −> Bool
--(*<*) (x1,y1) (x2,y2) = x1<x2 && y1<y2





