--2
--b)
import Data.List

data Tree23 = Empty
     | Node2 Char  Tree23  Tree23 
     | Node3 Char  Char Tree23  Tree23 Tree23 

myTree :: Tree23 
myTree = (Node3 'a' 'b' (Node3 'b' 'a' (Node3 'c' 'c' Empty Empty Empty)(Node3 'd' 'a' Empty Empty Empty)(Node2 'a' Empty Empty))(Node2 'a' (Node2 'b' Empty Empty) (Node2 'b' Empty Empty))(Node3 'c' 'a' (Node2 'c' Empty Empty) (Node2 'd' Empty Empty)(Node2 'c' Empty Empty)))

ta11 :: Tree23 -> [Char] -> [Char]
ta11 tree nume = nub (ta12 tree nume)

ta12 :: Tree23 -> [Char] -> [Char]
ta12 Empty cuv = []
ta12 (Node2 x st dr) cuv
     | elem x cuv = [x] ++ ta12 st cuv ++ ta12 dr cuv
     | otherwise = ta12 st cuv ++ ta12 dr cuv
ta12 (Node3 x y st mij dr) cuv
     | elem x cuv && elem y cuv = [x, y] ++ ta12 st cuv ++ ta12 mij cuv ++ ta12 dr cuv
     | elem x cuv  = [x] ++ ta12 st cuv ++ ta12 mij cuv ++ ta12 dr cuv
     | elem y cuv = [y] ++ ta12 st cuv ++ ta12 mij cuv ++ ta12 dr cuv
     | otherwise = ta12 st cuv ++ ta12 mij cuv ++ ta12 dr cuv

test111 :: Bool
test111 = ta11 myTree "abchj" == "abc"
test112 :: Bool
test112 = ta11 myTree "" == ""
test113 :: Bool
test113 = ta11 myTree "ABCd" == "d"





































{- TESTARE:
*Main> test111
True
*Main> test112
True
*Main> test113
True
-}

--c)

ta16 :: Tree23 -> [Char]
ta16 tree = sort (ta14 tree)

ta14 :: Tree23 -> [Char]
ta14 tree = nub (ta15 tree)

ta15 :: Tree23 -> [Char]
ta15 Empty = []
ta15 (Node2 x st dr) = [x] ++ ta15 st ++ ta15 dr
ta15 (Node3 x y st mij dr) = ta15 st ++ ta15 mij ++ ta15 dr 

instance Eq Tree23 where
    tree1 == tree2 = ta16 tree1 == ta16 tree2

myTree233 :: Tree23 
myTree233 = (Node3 'a' 'b' (Node3 'b' 'a' (Node3 'c' 'c' Empty Empty Empty)(Node3 'd' 'a' Empty Empty Empty)(Node2 'a' Empty Empty))(Node2 'a' (Node2 'b' Empty Empty) (Node2 'b' Empty Empty))(Node3 'c' 'a' (Node2 'd' Empty Empty) (Node2 'd' Empty Empty)(Node2 'd' Empty Empty)))

myTree234 :: Tree23
myTree234 = (Node2 'b' Empty (Node2 'a' Empty (Node2 'd' Empty Empty)))

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



--d)

data Tree2 = Vid | N Char Tree2 Tree2
           deriving Eq

ta13 :: Tree23 -> Tree2
ta13 Empty = Vid
ta13 (Node2 x st dr) = N x (ta13 st) (ta13 dr)
ta13 (Node3 x y st mij dr) = N x (ta13 st) (N y (ta13 mij) (ta13 dr))

myTree231 :: Tree23 
myTree231 = Node2 'a' Empty (Node2 'b' Empty Empty)

myTree21 :: Tree2
myTree21 = N 'a' Vid (N 'b' Vid Vid)

myTree232 :: Tree23 
myTree232 = Node2 'a' Empty (Node3 'b' 'c' Empty Empty Empty)

myTree22 :: Tree2
myTree22 = N 'a' Vid (N 'b' Vid (N 'c' Vid Vid))


test131 :: Bool
test131 = ta13 myTree231 == myTree21
test132 :: Bool
test132 = ta13 myTree232 == myTree22
test133 :: Bool
test133 = ta13 myTree232 == myTree21

{-TESTARE:
*Main> test131
True
*Main> test132
True
-}

--3



