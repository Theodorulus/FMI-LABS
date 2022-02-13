import Numeric.Natural


logistic :: Num a => a -> a -> Natural -> a
logistic rate start = f
  where
    f 0 = start
    f n = rate * f (n - 1) * (1 - f (n - 1))




logistic0 :: Fractional a => Natural -> a
logistic0 = logistic 3.741 0.00079
ex1 :: Natural
ex1 = 20


ex20 :: Fractional a => [a]
ex20 = [1, logistic0 ex1, 3]

ex21 :: Fractional a => a
ex21 = head ex20

ex22 :: Fractional a => a
ex22 = ex20 !! 2

ex23 :: Fractional a => [a]
ex23 = drop 2 ex20

ex24 :: Fractional a => [a]
ex24 = tail ex20


ex31 :: Natural -> Bool
ex31 x = x < 7 || logistic0 (ex1 + x) > 2

ex32 :: Natural -> Bool
ex32 x = logistic0 (ex1 + x) > 2 || x < 7
ex33 :: Bool
ex33 = ex31 5

ex34 :: Bool
ex34 = ex31 7

ex35 :: Bool
ex35 = ex32 5

ex36 :: Bool
ex36 = ex32 7

sumaPatrateImpare :: [Integer] -> Integer
sumaPatrateImpare [] = 0
sumaPatrateImpare (a:as)
   | odd a = a * a + sumaPatrateImpare as
   | otherwise = sumaPatrateImpare as

sumaPatrateImpareFold :: [Integer] -> Integer
sumaPatrateImpareFold = foldr op unit
   where
    unit = 0
    a `op` suma
       | odd a = a * a + suma
       | otherwise = suma

funct x = x * x * x

map_ :: (a -> b) -> [a] -> [b]
map_ f [] = []
map_ f (a:as) = f a : map_ f as

mapFold :: (a -> b) -> [a] -> [b]
mapFold f = foldr op unit
   where
      unit = []
      a `op` l = f a : l

filter_ :: (a -> Bool) -> [a] -> [a]
filter_ p [] = []
filter_ p (a:as)
     | p a = a : filter_ p as
     | otherwise = filter_ p as

filterFold :: (a -> Bool) -> [a] -> [a]
filterFold p = foldr op unit
   where
     unit = []
     a `op` filtered
       | p a = a : filtered
       | otherwise = filtered
{-
sgn_nr :: Integer -> Char
sgn_nr x
     | x == 0 = '0'
     | x < 0 = '-'
     | x > 0 = '0'
NU STIU DE CE NU MERGE!!!
-}
semn :: [Integer] -> String
semn [] = ""
semn (a:as)
      | a > 0 && a <= 9 = "+" ++ semn as
      | a < 0 && a >= -9 = "-" ++ semn as
      | a == 0 = "0" ++ semn as
      | otherwise = semn as


semnFold :: [Integer] -> String
semnFold = foldr op unit
   where
     unit = ""
     a `op` rest
         | a > 0 && a <= 9 = "+" ++ rest
         | a < 0 && a >= -9 = "-" ++ rest
         | a == 0 = "0" ++ rest
         | otherwise = rest
     
     
     
matrice :: Num a => [[a]]
matrice = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]     

corect :: [[a]] -> Bool
corect matrix = foldr(\(x, y) b -> x == y && b) True (zip list (tail list))
     where 
          list = (map (\x -> length x) matrix)

el :: [[a]] -> Int -> Int -> a 
el m i j = (m !! i) !! j 

enumera :: [a] -> [(a,Int)]
enumera list = zip list [0..]

insereazaPozitie :: ([(a, Int)], Int) -> [(a, Int, Int)]
insereazaPozitie (lista, linie) = 
     map (\(x, coloana) -> (x, linie, coloana)) lista

transforma :: [[a]] -> [(a, Int, Int)]
transforma matrix = concat (map insereazaPozitie (enumera (map enumera matrix)))