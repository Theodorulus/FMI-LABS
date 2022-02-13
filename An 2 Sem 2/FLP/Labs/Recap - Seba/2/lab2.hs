import Data.List
import Data.Maybe

type Name = String

data  Pgm  = Pgm [Name] Stmt
        deriving (Read, Show)

data Stmt = Skip | Stmt ::: Stmt | If BExp Stmt Stmt | While BExp Stmt | Name := AExp
        deriving (Read, Show)

data AExp = Lit Integer | AExp :+: AExp | AExp :*: AExp | Var Name
        deriving (Read, Show)

data BExp = BTrue | BFalse | AExp :==: AExp | Not BExp
        deriving (Read, Show)

infixr 2 :::
infix 3 :=
infix 4 :==:
infixl 6 :+:
infixl 7 :*:


type Env = [(Name, Integer)]


factStmt :: Stmt
factStmt =
  "p" := Lit 1 ::: "n" := Lit 3 :::
  While (Not (Var "n" :==: Lit 0))
    ( "p" := Var "p" :*: Var "n" :::
      "n" := Var "n" :+: Lit (-1)
    )
    
pg1 = Pgm [] factStmt 


aEval :: AExp -> Env -> Integer
aEval (Lit i) env = i
aEval (a :+: b) env = aEval a env + aEval b env
aEval (a :*: b) env = aEval a env * aEval b env
aEval (Var n) env = fromJust $ lookup n env

bEval :: BExp -> Env -> Bool
bEval BTrue env = True
bEval BFalse env = False 
bEval (a :==: b) env = aEval a env == aEval b env
bEval (Not exp) env = not (bEval exp env)

sEval :: Stmt -> Env -> Env
sEval Skip env = env
sEval (a ::: b) env = sEval b (sEval a env)
sEval (If exp a b) env = sif (bEval exp env) (sEval a env) (sEval b env) where
    sif True a b = a
    sif False a b = b
sEval (While a b) env = case (bEval a env) of 
    True -> sEval (While a b) (sEval b env)
    False -> env
sEval (name := exp) env = (name, (aEval exp env)) : filter (\(k,v) -> k /= name) env


pEval :: Pgm -> Env
pEval (Pgm var st) = sEval st (envFromNames var)


envFromNames :: [Name] -> Env
envFromNames names = [(name, 0) | name <- names]
