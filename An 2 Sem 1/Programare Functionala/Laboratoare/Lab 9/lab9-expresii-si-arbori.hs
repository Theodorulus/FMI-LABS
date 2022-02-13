data Expr = Const Int -- integer constant
          | Expr :+: Expr -- addition
          | Expr :*: Expr -- multiplication
           deriving Eq
data Operation = Add | Mult deriving (Eq, Show)

data Tree = Lf Int -- leaf
          | Node Operation Tree Tree -- branch
           deriving (Eq, Show)
           
instance Show Expr where
                    show (Const x) = show x
                    show (a :+: b) = "(" ++ (show a) ++ " + " ++ show b ++ ")"
                    show (a :*: b) = "(" ++ (show a) ++ " * " ++ show b ++ ")"

evalExp :: Expr -> Int
evalExp (Const x) = x
evalExp (a :+: b) = (evalExp a) + evalExp b
evalExp (a :*: b) = (evalExp a) * evalExp b

exp1 = (Const 2 :*: Const 3) :+: (Const 0 :*: Const 5)
exp2 = Const 2 :*: (Const 3 :+: Const 4)
exp3 = Const 4 :+: (Const 3 :*: Const 3)
exp4 = ((Const 1 :*: Const 2) :*: (Const 3 :+: Const 1)) :*: Const 2

test11 = evalExp exp1 == 6
test12 = evalExp exp2 == 14
test13 = evalExp exp3 == 13
test14 = evalExp exp4 == 16

evalArb :: Tree->Int
evalArb (Lf x) = x
evalArb (Node Add a b)= evalArb a + evalArb b
evalArb (Node Mult a b)= evalArb a * evalArb b

expToArb :: Expr -> Tree
expToArb (Const x) = Lf x 
expToArb (a :+: b) = Node Add (expToArb a) (expToArb b)
expToArb (a :*: b) = Node Mult (expToArb a) (expToArb b)

arb1 = Node Add (Node Mult (Lf 2) (Lf 3)) (Node Mult (Lf 0)(Lf 5))
arb2 = Node Mult (Lf 2) (Node Add (Lf 3)(Lf 4))
arb3 = Node Add (Lf 4) (Node Mult (Lf 3)(Lf 3))
arb4 = Node Mult (Node Mult (Node Mult (Lf 1) (Lf 2)) (Node Add (Lf 3)(Lf 1))) (Lf 2)

test21 = evalArb arb1 == 6
test22 = evalArb arb2 == 14
test23 = evalArb arb3 == 13
test24 = evalArb arb4 == 16

class MySmallCheck a where
     smallValues :: [a]
     smallCheck :: ( a -> Bool ) -> Bool
     smallCheck prop = and [ prop x | x <- smallValues ]
     
instance MySmallCheck Expr where
    smallValues=[exp1,exp2,exp3,exp4]

checkExp :: Expr -> Bool
checkExp exprr= (evalExp exprr) == evalArb(expToArb exprr)





