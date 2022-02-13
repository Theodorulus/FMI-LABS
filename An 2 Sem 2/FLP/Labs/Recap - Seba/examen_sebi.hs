{-
Gasiti mai jos  un minilimbaj. Interpretarea este partial definita.
Un program este o expresie de tip `Pgm` iar rezultatul executiei este ultima stare a 
memoriei. 
Executia unui program se face apeland `pEval`.
-}

import Data.Maybe
import Data.List

type Name = String

data  Pgm  = Pgm [Name] Stmt
        deriving (Read, Show)

data Stmt = Skip | Stmt ::: Stmt | If BExp Stmt Stmt| Name := AExp | While BExp Stmt
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


aEval :: AExp -> Env -> Integer
aEval (Lit int) env = int
aEval (a1 :+: a2) env = aEval a1 env + aEval a2 env
aEval (a1 :*: a2) env = aEval a1 env * aEval a2 env
aEval (Var nume) env = fromJust $ lookup nume env

bEval :: BExp -> Env -> Bool
bEval BTrue env = True
bEval BFalse env = False
bEval (a1 :==: a2) env = aEval a1 env == aEval a2 env
bEval (Not b) env = not $ bEval b env

sEval :: Stmt -> Env -> Env
sEval Skip env = env
sEval (s1 ::: s2) env = sEval s2 (sEval s1 env)
sEval (If b s1 s2) env = if bEval b env then sEval s1 env else sEval s2 env
sEval (nume := a) env = (nume, aEval a env) : filter (\(k,v) -> k /= nume) env
sEval (While b1 st) env = if bEval b1 env then sEval (While b1 st) (sEval st env) else env

pEval :: Pgm -> Env
pEval (Pgm lvar st) = sEval st []

factStmt :: Stmt
factStmt =
  "p" := Lit 1 ::: "n" := Lit 3 :::
  While (Not (Var "n" :==: Lit 0))
    ( "p" := Var "p" :*: Var "n" :::
      "n" := Var "n" :+: Lit (-1)
    )

factStmt2 :: Stmt
factStmt2 =
  "p" := Lit 1 :::
  While (Not (Var "n" :==: Lit 0))
    ( "p" := Var "p" :*: Var "n" :::
      "n" := Var "n" :+: Lit (-1)
    )

test1 = Pgm [] factStmt

test2 = Pgm ["n"] factStmt2

makeEnv :: [Name] -> Env
makeEnv l = [(nume, 0) | nume <- l]

pEval2 :: Pgm -> (Env,Env)
pEval2 (Pgm lvar st) = (makeEnv lvar, sEval st (makeEnv lvar))

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10pct) Adaugati instructiunea `While BExp Stmt` si interpretarea ei.
3) (20pct) Definiti interpretarea limbajului astfel incat programele sa se execute dintr-o stare 
initiala data iar  `pEval`  sa afiseze starea initiala si starea finala.    

Definiti teste pentru verificarea solutiilor si indicati raspunsurile primite. 

-}