
-- la nevoie decomentati liniile urmatoare:

import Data.Char
import Data.List


---------------------------------------------
-------RECURSIE: FIBONACCI-------------------
---------------------------------------------

fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
  | n < 2     = n
  | otherwise = fibonacciCazuri (n - 1) + fibonacciCazuri (n - 2)

fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n =
    fibonacciEcuational (n - 1) + fibonacciEcuational (n - 2)

{-| @fibonacciLiniar@ calculeaza @F(n)@, al @n@-lea element din secvența
Fibonacci în timp liniar, folosind funcția auxiliară @fibonacciPereche@ care,
dat fiind @n >= 1@ calculează perechea @(F(n-1), F(n))@, evitănd astfel dubla
recursie. Completați definiția funcției fibonacciPereche.

Indicație:  folosiți matching pe perechea calculată de apelul recursiv.
-}
fibonacciLiniar :: Integer -> Integer
fibonacciLiniar 0 = 0
fibonacciLiniar n = snd (fibonacciPereche n)
  where
    fibonacciPereche :: Integer -> (Integer, Integer)
    fibonacciPereche 1 = (0, 1)
    fibonacciPereche n = (b, a + b)
                         where 
                         (a, b) = fibonacciPereche (n-1)

---------------------------------------------
----------RECURSIE PE LISTE -----------------
---------------------------------------------
semiPareRecDestr :: [Int] -> [Int]
semiPareRecDestr l
  | null l    = l
  | even h    = h `div` 2 : t'
  | otherwise = t'
  where
    h = head l
    t = tail l
    t' = semiPareRecDestr t

semiPareRecEq :: [Int] -> [Int]
semiPareRecEq [] = []
semiPareRecEq (h:t)
  | even h    = h `div` 2 : t'
  | otherwise = t'
  where t' = semiPareRecEq t

---------------------------------------------
----------DESCRIERI DE LISTE ----------------
---------------------------------------------
semiPareComp :: [Int] -> [Int]
semiPareComp l = [ x `div` 2 | x <- l, even x ]


-- L2.2
inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec lo hi [] = []
inIntervalRec lo hi (h:t)
   | (h >= lo) && (h <= hi) = h : (inIntervalRec lo hi t)
   | otherwise = inIntervalRec lo hi t

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp lo hi xs = [x | x <- xs, x >= lo && x <= hi]

-- L2.3

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (h:t)
   | h > 0 = 1 + pozitiveRec(t)
   | otherwise = pozitiveRec(t)


pozitiveComp :: [Int] -> Int
pozitiveComp l = length[x | x <- l, x > 0]

-- L2.4 
pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec l = pozitiiImpareRecAux l 0
pozitiiImpareRecAux [] _ = []
pozitiiImpareRecAux (h:t) a
   | odd h = a:(pozitiiImpareRecAux t (a+1))
   | otherwise = pozitiiImpareRecAux t (a+1)


pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = [fst x | x <- zip [0,1..] l, snd x `mod` 2 == 1]


-- L2.5

multDigitsRec :: String -> Int
multDigitsRec [] = 1
multDigitsRec (h:t) 
   | isDigit h = Data.Char.digitToInt h * (multDigitsRec t)
   | otherwise = multDigitsRec t

multDigitsComp :: String -> Int
multDigitsComp sir = product [Data.Char.digitToInt x | x <- sir, isDigit x]

-- L2.6 

discountRec :: [Float] -> [Float]
discountRec [] = []
discountRec (h:t)
   | 0.75 * h < 200 = 0.75 * h : discountRec t
   | otherwise = discountRec t

discountComp :: [Float] -> [Float]
discountComp list = [0.75 * x | x <- list, 0.75 * x < 200]


