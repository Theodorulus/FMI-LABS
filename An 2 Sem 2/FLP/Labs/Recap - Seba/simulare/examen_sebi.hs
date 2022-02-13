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

bEval :: BExp -> Env -> Bool

sEval :: Stmt -> Env -> Env

pEval :: Pgm -> Env
pEval (Pgm lvar st) = sEval st [] 

factStmt :: Stmt
factStmt =
  "p" := Lit 1 ::: "n" := Lit 3 :::
  While (Not (Var "n" :==: Lit 0))
    ( "p" := Var "p" :*: Var "n" :::
      "n" := Var "n" :+: Lit (-1)
    )

test1 = Pgm [] factStmt

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10pct) Adaugati instructiunea `While BExp Stmt` si interpretarea ei.
3) (20pct) Definiti interpretarea limbajului astfel incat programele sa se execute dintr-o stare 
initiala data iar  `pEval`  sa afiseze starea initiala si starea finala.    

Definiti teste pentru verificarea solutiilor si indicati raspunsurile primite. 

-}