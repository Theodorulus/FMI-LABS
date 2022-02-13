{-

Fie tipul de date `Arb` dat de definiția de mai jos. Aceste definiții vor fi folosite pentru toate exercițiile care urmează.


Pentru fiecare exercițiu, indicați testele pe care le-ați folosit în verificarea soluțiilor.
-}

import Data.Maybe

type Val = Int
data Operatie = Add | If Operatie Operatie
data Lit = V Val | Id String
data Arb
   = Leaf Lit
   | Node Operatie [Arb]

type Stare = [(String, Val)]   -- valori pentru identificatorii (`Id x`) din arbore

add1 :: [Arb] -> Stare -> Val
add1 (h:t) env = eval h env + add1 t env
add1 [] env = 0


eval :: Arb -> Stare -> Val
eval (Leaf v) env = val v env
eval (Node Add s) env = add1 s env 
eval (Node (If op1 op2) s) env = fct_if s op1 op2 env where
    fct_if (h:t) op1 op2 env = 
        if test (eval h env) then
            eval (Node op1 t) env
        else
            eval (Node op2 t) env
    fct_if [] op1 op2 env = error "lista vida"




val :: Lit -> Stare -> Val
val (V v) _ = v
val (Id nume) env = let v = lookup nume env in case v of
    Just v -> v
    Nothing -> error "Variabila negasita"


test :: Val -> Bool
test = (/= 0)


test1 = Node Add [Leaf (V 1), Leaf (V 2), Leaf (V 3)]

test2 = Node Add [Leaf (V 1), Leaf (Id "id1"), Leaf (V 2)]

test3 = Node Add []

test4 = Node Add [Leaf (V 1), Leaf (Id "id1"), Node Add [Leaf (V 2), Leaf (V 5)], Leaf (V 3)]

test5 = Node Add [Leaf (V 1), Node (If Add Add) [Leaf (V 2), Leaf (V 5), Leaf (V 3)], Leaf (V 1)]

test6 = Node Add [Leaf (V 1), Node (If Add Add) [], Leaf (V 1)]



{-
Teste folosite:

*Main> eval test1 []
6
*Main> eval test2 []
*** Exception: Variabila negasita
*Main> eval test3 []
0
*Main> eval test4 [("id1", 2)]
13
*Main> eval test5 []
10
*Main> eval test6 []
*** Exception: lista vida
-}