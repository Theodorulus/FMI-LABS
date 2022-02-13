import Data.Char
import Data.List
--import Data.List.Unique

--Exercitiul 2
--1)
tar21 :: String -> Bool
tar21 "" = True
tar21 (h:t)
   | elem h "AEIOU" = tar21 t
   | elem h "aeiou" = False
   | otherwise = tar21 t
{-
In condiitile in care caracterul curent din string este o vocala litera mare sau este orice alt caracter,
cu exceptia unei vocale litera mica, apelez functia recursiv. Daca string-ul nu contine nicio vocala litera mica
atunci se va ajunge la expresia 'tar21 "" = True', deci se va returna True. In celalalt caz, se va returna False.
Exemple testate:
*Main> tar21 "AEIOUghKLAE"
True
*Main> tar21 "aAAEEO"
False
*Main> tar21 "AAEafTrsDEO"
False
-}

--2)
tar22 :: String -> Bool
tar22 str = and [isUpper c | c <- str, elem c "AEIOUaeiou"]
{-
Extrag din string in variabila 'c' doar vocalele, dupa care functia isUpper va returna True sau False
pentru fiecare vocala extrasa. Daca printre aceste valori bool-ene se va afla un False, functia de agregare
'and' va returna False, altfel va returna True.
Exemple testate:
*Main> tar22 "AEIOUghKLAE"
True
*Main> tar22 "aAAEEO"
False
*Main> tar22 "AAEafTrsDEO"
False
-}

--3)
tar23 str = foldr (&&) True (map isUpper (filter vocala str))

vocala :: Char -> Bool
vocala c = if (elem c "AEIOUaeiou")
              then True
              else False
{-
Am creat o functie auxiliara 'vocala' pentru a extrage numai vocalele folosind functia filter.
Folosing functia 'map' si 'isUpper' am creat o lista de valori bool-ene pe care am aplicat functia
'foldr', aceasta din urma avand aceeasi functionalitate ca 'and' de la subpunctul anterior
Exemple testate:
*Main> tar23 "AEIOUghKLAE"
True
*Main> tar23 "aAAEEO"
False
*Main> tar23 "AAEafTrsDEO"
False
-}

--4)
tar24 :: String -> Bool
tar24 str =  tar21 str == tar22 str
{-
Exemple testate:
*Main> tar24 "AEIOUghKLAE"
True
*Main> tar24 "aAAEEO"
True
*Main> tar24 "AAEafTrsDEO"
True
-}

--Exercitiul 3
--tar30 :: [Int] -> Int
{-
tar30aux [] = []
tar30aux (h:t)
   | h `elem` t = h : tar30aux t
   |otherwise = tar30aux t

tar30 list = length (unique (tar30aux list))
-}










