import Numeric.Natural
import Test.QuickCheck

--1

produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (h:t) = h * produsRec t


produsFold :: [Integer] -> Integer
produsFold list = foldr (*) 1 list

prop_produs x = produsRec x == produsFold x

{-
*Main> quickCheck prop_produs
+++ OK, passed 100 tests.
-}

--2

andRec :: [Bool] -> Bool
andRec [] = True
andRec (h:t) = h && andRec t


andFold :: [Bool] -> Bool
andFold list = foldr (&&) True list

prop_and x = andRec x == andFold x

{-
*Main> quickCheck prop_and
+++ OK, passed 100 tests.
-}

--3

concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (h:t) = h ++ concatRec t


concatFold :: [[a]] -> [a]
concatFold list = foldr (++) [] list

prop_concat x = concatRec x == concatFold x

{-
*Main> quickCheck prop_concat
+++ OK, passed 100 tests.
-}

--4

rmChar :: Char -> String -> String
rmChar chr str = filter (/= chr) str

{-
rmCharsRec :: String -> String -> String
rmCharsRec _ [] = []
rmCharsRec c (x:xs) = (if x == c then [] else [x]) ++ (rmCharRec c xs)
-}

test_rmchars :: Bool
test_rmchars = rmCharsRec ['a'..'l'] "fotbal" == "ot"



rmCharsFold :: String -> String -> String
rmCharsFold = undefined



logistic :: Num a => a -> a -> Natural -> a
logistic rate start = f
  where
    f 0 = start
    f n = rate * f (n - 1) * (1 - f (n - 1))




logistic0 :: Fractional a => Natural -> a
logistic0 = logistic 3.741 0.00079
ex1 :: Natural
ex1 = undefined


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
