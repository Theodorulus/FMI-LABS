import Test.QuickCheck
import Data.Char
import Test.QuickCheck.Gen

--Lab 7

double :: Int -> Int
double x = 2 * x
triple :: Int -> Int
triple x = 3 * x
penta :: Int -> Int
penta x = 5 * x

test x = (double x + triple x) == (penta x)

-- *Main> quickCheck test
-- +++ OK, passed 100 tests.

testFals x = (double x) == (triple x)

-- *Main> quickCheck testFals
-- *** Failed! Falsified (after 2 tests):
-- 1

myLookUp :: Int -> [(Int, String)] -> Maybe String
myLookUp _ [] = Nothing
myLookUp nr (x:xs)
   | nr == fst x = Just (snd x)
   | otherwise = myLookUp nr xs

testLookUp :: Int -> [(Int,String)] -> Bool
testLookUp x l= (myLookUp x l) == (lookup x l)

testLookUpCond :: Int -> [(Int,String)] -> Property
testLookUpCond n list = n > 0 && n `div` 5 == 0 ==> testLookUp n list

myLookUp2 :: Int -> [(Int,String)]-> Maybe String
myLookUp2 _ [] = Nothing
myLookUp2 nr (x:xs)
   | nr == fst x && snd x == "" = Just ""
   | nr == fst x = Just (toUpper(head(snd x)) : tail (snd x))
   | otherwise = myLookUp2 nr xs

testLookUp2 :: Int -> [(Int,String)] -> Bool
testLookUp2 x l = myLookUp2 x l == lookup x l

--DE DISCUTAT
testLookUpCond2 :: Int -> [(Int,String)] -> Property
testLookUpCond2 n list = foldr (&&) True (map (\x -> toUpper(head(snd x))==head(snd x)) list ) ==> testLookUp2 n list

capitalized :: String -> String
capitalized (h:t) = (toUpper h): t
capitalized [] = []

testLookUpCond22 :: Int -> [(Int,String)] -> Property
testLookUpCond22 n list = foldr (&&) True (map (\x -> (capitalized(snd x))== (snd x)) list ) ==> testLookUp2 n list

data ElemIS = I Int | S String
     deriving (Show,Eq)

instance Arbitrary ElemIS where
     arbitrary = oneof [geni, gens]
	             where
                  f = (unGen ( arbitrary :: Gen Int ))
				  geni = MkGen ( \s i -> let x = f s i in (I x))
				  g = (unGen ( arbitrary :: Gen String ))
				  gens = MkGen ( \s i -> let x = g s i in (S x))

myLookUpElem :: Int -> [(Int,ElemIS)]-> Maybe ElemIS
myLookUpElem _ [] = Nothing
myLookUpElem nr (x:xs)
   | nr == fst x = Just (snd x)
   | otherwise = myLookUpElem nr xs

testLookUpElem :: Int -> [(Int,ElemIS)] -> Bool
testLookUpElem i l = myLookUpElem i l == lookup i l






