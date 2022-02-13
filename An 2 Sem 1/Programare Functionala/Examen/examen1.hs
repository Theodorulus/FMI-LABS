import Data.List ( nub )

data Tree23 = Empty
     | Node2 Char  Tree23  Tree23 
     | Node3 Char  Char Tree23  Tree23 Tree23


myTree :: Tree23 
myTree = (Node3 'a' 'b' (Node3 'b' 'a' (Node3 'c' 'c' Empty Empty Empty)(Node3 'd' 'a' Empty Empty Empty)(Node2 'a' Empty Empty))(Node2 'a' (Node2 'b' Empty Empty) (Node2 'b' Empty Empty))(Node3 'c' 'a' (Node2 'c' Empty Empty) (Node2 'd' Empty Empty)(Node2 'c' Empty Empty)))

myTree233 :: Tree23 
myTree233 = (Node3 'a' 'b' (Node3 'b' 'a' (Node3 'c' 'c' Empty Empty Empty)(Node3 'd' 'a' Empty Empty Empty)(Node2 'a' Empty Empty))(Node2 'a' (Node2 'b' Empty Empty) (Node2 'b' Empty Empty))(Node3 'c' 'a' (Node2 'd' Empty Empty) (Node2 'd' Empty Empty)(Node2 'd' Empty Empty)))

myTree234 :: Tree23
myTree234 = (Node2 'a' Empty (Node2 'b' Empty (Node2 'd' Empty Empty)))

ta14 :: Tree23 -> [Char]
ta14 tree = nub (ta15 tree)

ta15 :: Tree23 -> [Char]
ta15 Empty = []
ta15 (Node2 x st dr) = [x] ++ ta15 st ++ ta15 dr
ta15 (Node3 x y st mij dr) = ta15 st ++ ta15 mij ++ ta15 dr 

instance Eq Tree23 where
    tree1 == tree2 = ta14 tree1 == ta14 tree2


test121 = (myTree == myTree233) == False
test122 = (myTree == myTree234) == False
test123 = (myTree233 == myTree234) == True

{-TESTARE:
*Main> test121
True
*Main> test122
True
*Main> test123
True
-}

data B e = R e Int | B e ::: B e
    deriving Eq
infixr 5 :::

instance Foldable B where
    foldMap ta21 (R a x) = ta21 a
    foldMap ta21 (a:::b) = foldMap ta21 a `mappend` foldMap ta21 b

fTest0 :: Bool
fTest0 = maximum (R "nota" 2 ::: R "zece" 3 ::: R "la" 5 ::: R "examen" 1) == "zece"
fTest1 :: Bool
fTest1 = maximum (R "nota" 2 ::: R "abc" 3 ::: R "la" 5 ::: R "examen" 1) == "nota"
fTest2 :: Bool
fTest2 = minimum (R "nota" 2 ::: R "zece" 3 ::: R "la" 5 ::: R "examen" 1) == "examen"

{-TESTARE:
*Main> fTest0
True
*Main> fTest1
True
*Main> fTest2
True
*Main>
-}