import Data.Char

--Test

--Exercitiul 1
--a)

f:: Char -> Bool
f c = if (elem c "abcdefghijklmABCDEFGHIJKLM")
      then True
      else if (elem c "nopqrstuvwxyzNOPQRSTUVWXYZ")
           then False
           else error "eroare"


--b)

g :: String -> Bool
g str = length[c | c <- str, isAlpha c && f c == True] > length[c | c <- str, isAlpha c && f c == False]

--c)

h :: String -> Bool
h s = nrPrimaJum s > nrADouaJum s

nrPrimaJum [] = 0
nrPrimaJum (c:s)
   | isAlpha c && f c == True = 1 + nrPrimaJum s
   | otherwise = nrPrimaJum s

nrADouaJum [] = 0
nrADouaJum (c:s)
   | isAlpha c && f c == False = 1 + nrADouaJum s
   | otherwise = nrADouaJum s

--Exercitiul 2
--a)

c :: [Int] -> [Int]
c list = [fst a | a <- zip list (tail list), fst a == snd a]

--b)

d :: [Int] -> [Int]
d [] = []
d (h:t)
     | length t /= 0 && h == head t = h : d t
     | otherwise = d t

--c)

prop_cd l = c l == d l

{-
*Main> prop_ex2 [3,1,1,3,3,5]
True
*Main> prop_ex2 [2,1,4,1,2]
True
*Main> prop_ex2 [4,1,1,1,4,4]
True
*Main>
-}

--Laborator

--Exercitiul 1

data Fruct
     = Mar String Bool
     | Portocala String Int

--a)

ePortocalaDeSicilia (Portocala x _) = x `elem` ["Tarocco", "Moro", "Sanguinello"]
ePortocalaDeSicilia _ = False

--b)

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia [] = 0
nrFeliiSicilia (h:t)
     | ePortocalaDeSicilia h = nrFelii h + nrFeliiSicilia t
     | otherwise = nrFeliiSicilia t

nrFelii (Portocala x y)= y

nrFeliiSicilia2 l = sum [x | Portocala _ x <- filter ePortocalaDeSicilia l]

listaFructe = [Mar "Ionatan" False, Portocala "Sanguinello" 10, Portocala "Valencia" 22, Mar "Golden Delicious" True, Portocala "Sanguinello" 15, Portocala "Moro" 12, Portocala "Tarocco" 3, Portocala "Moro" 12, Portocala "Valencia" 2, Mar "Golden Delicious" False, Mar "Golden" False, Mar "Golden" True]

--c)

nrMereViermi :: [Fruct] -> Int
nrMereViermi l = length [x | Mar _ x <- l, x == True]

nrMereViermi1 :: [Fruct] -> Int
nrMereViermi1 [] = 0
nrMereViermi1 (h:t) 
     | areViermi h = 1 + nrMereViermi1 t
     | otherwise = nrMereViermi1 t

areViermi (Mar _ True) = True
areViermi _ = False

--Exercitiul 2

data Linie = L [Int]
   deriving Show
data Matrice = M [Linie]

verifica :: Matrice -> Int -> Bool
verifica (M m) n = foldr (&&) True [(foldr (+) 0 linie) == n | L linie <- m]

showLine :: Linie -> [Char]
showLine (L []) = ""
showLine (L (x:[])) = show(x)
showLine (L (x:xs)) = show(x) ++ " " ++ showLine(L xs)

instance Show Matrice where
    show (M []) = ""
    show (M (x:[])) = (showLine x)
    show (M (x:xs)) = (showLine x) ++ "\n" ++ (show (M xs))

elemPoz l = and[x > 0 | x <- l]

doarPozN :: Matrice -> Int -> Bool
doarPozN (M m) n = and [elemPoz l | L l <- m, length l == n]




