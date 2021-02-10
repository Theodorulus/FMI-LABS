import Data.List
import Data.Char

{-
1.
Fie următorul tip de date arborescent care conține informații în fiecare nod intermediar și în frunze.

data Arbore a
    = Nod (Arbore a) a (Arbore a)
    | Frunza a | Vid

Vrem să implementăm câteva funcții pentru acest tip de date peste o mulțime ordonată,
care să mențină proprietatea de arbore de căutare, adică,

Arborele nu contine duplicate
Pentru orice element de forma (Nod aStanga v aDreapta),
- toate elementele conținute în aStanga sunt (strict) mai mici decat v
- toate elementele continute in aDreapta sunt (strict) mai mari decat v
(a) Scrieți o funcție care dat fiind un obiect de tip arbore (peste o multime ordonata) verifica proprietatea de arbore de cautare

(b) Scrieti o functie care insereaza un element intr-un arbore, pastrand proprietatea de arbore de cautare.

(c) Faceți Arbore instanță a clasei Functor


2.
(a) Faceti Arbore instanță a clasei Foldable

(b) Faceti Arbore instanta a clasei Show. Pentru un arbore care respecta proprietatea de arbore de cautare, 
show va afisa elementele arborelui, in ordine crescatoare, separate prin virgula.  Puteti folosi instanta de la punctul (a)

-}

--Exercitiul 1

data Arbore a = Nod (Arbore a) a (Arbore a)
               | Frunza a 
               | Vid

{-
instance (Eq a) => Eq (Arbore a) where
    Vid == Vid = True  
    (Frunza x)  == (Frunza y)   = x == y
    (Nod _ x _) == (Frunza y)   = x == y
    (Frunza x)  == (Nod _ y _)  = x == y
    (Nod _ x _) == (Nod _ y _)  = x == y
    _ == _ = False

instance (Ord a) => Ord (Arbore a) where
    Vid <= _ = True
    _ <= Vid = True
    (Frunza x)  <= (Frunza y)   = x <= y
    (Nod _ x _) <= (Frunza y)   = x <= y
    (Frunza x)  <= (Nod _ y _)  = x <= y
    (Nod _ x _) <= (Nod _ y _)  = x <= y
-}

verify :: (Eq a, Ord a, Bounded a) => Arbore a -> Bool
verify Vid = True
verify (Frunza x) = True
verify (Nod st x dr) = isBST st minBound x && isBST dr x maxBound

isBST :: (Eq a, Ord a, Bounded a) => Arbore a -> a -> a -> Bool
isBST (Frunza x) min max = x > min && x < max
isBST Vid min max= True
isBST (Nod st x dr) min max
     | x > min && x < max = isBST st min x && isBST dr x max
     | otherwise = False

arb :: Arbore Int
arb = 
    Nod (Nod Vid 2 (Frunza 5)) 4 Vid

insertArb :: (Eq a, Ord a) => a -> Arbore a -> Arbore a
insertArb x Vid = Frunza x
insertArb x (Frunza y)
     | x == y = Frunza x
     | x > y = Nod Vid y (Frunza x)
     | otherwise = Nod (Frunza x) y Vid
insertArb x (Nod st y dr)
     | x == y = Nod st x dr
     | x > y = Nod st y (insertArb x dr)
     | otherwise = Nod (insertArb x st) y dr


arb1 :: Arbore Int
arb1 = 
    Nod (Nod Vid 2 (Frunza 3)) 5 Vid

arb2 :: Arbore Int
arb2 = insertArb 4 arb1

instance (Show a) => Show (Arbore a) where
     show Vid = ""
     show (Frunza x) = show(x) ++ ", "
     show (Nod st x dr) = show st ++ show(x) ++ ", " ++  show dr

--test2 = arb2 == (Nod (Nod Vid 2 (Nod Vid 3 (Frunza 4)) 5 Vid)

--class Functor where
--     fmap :: (a -> b) -> 

instance Functor Arbore where
     fmap f Vid = Vid
     fmap f (Nod st x dr) = Nod (fmap f st) (f x) (fmap f dr)
     fmap f (Frunza x) = Frunza (f x)


instance Foldable Arbore where
    foldMap f Vid = mempty
    foldMap f (Frunza x) = f x
    foldMap f (Nod st x dr) = foldMap f st `mappend` f x `mappend` foldMap f dr

{-
instance Foldable Tree where
   foldr f z Empty = z
   foldr f z (Leaf x) = f x z
   foldr f z (Node l k r) = foldr f (f k (foldr f z r)) l
-}


data Binar a = Leaf a
              | Node (Binar a) (Binar a) 

tree = Node (Node (Leaf 3) (Leaf 4)) (Node (Node (Leaf 1) (Leaf 2)) (Leaf 5))

encoding :: Binar a -> [(a, [Bool])]
encoding arb = enc arb []


enc :: Binar a -> [Bool] -> [(a, [Bool])]
enc (Leaf x) l = [(x, l)]
enc (Node st dr) l = (enc st (l ++ [True])) ++ (enc dr (l ++ [False]))


litere = [(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd'), (5, 'e'), (6, 'f'), (7, 'g'), (8, 'h')]

type Linie = Int
type Coloana = Char
type Pozitie = (Coloana, Linie)

type DeltaLinie = Int
type DeltaColoana = Int
type Mutare = (DeltaColoana, DeltaLinie)

mutaDacaValid :: Pozitie -> Mutare -> Pozitie
mutaDacaValid poz m
     | x > 0 && x < 9 && y > 0 && y < 9 = (chr (y + 96), x)
     | otherwise = poz
       where x = snd poz + snd m
             y = ord (fst poz) + fst m - 96

ex1t1, ex1t2, ex1t3 :: Bool
ex1t1 = mutaDacaValid ('e', 5) (1, -2) == ('f', 3)
ex1t2 = mutaDacaValid ('b', 5) (-2, 1) == ('b', 5)
ex1t3 = mutaDacaValid ('e', 2) (1, -2) == ('e', 2)