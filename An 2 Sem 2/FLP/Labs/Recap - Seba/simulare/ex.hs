--- Richtieanu Mihai-Sebastian 242
{-
Gasiti mai jos  un minilimbaj. Interpretarea este partial definita.
Un program este o expresie de tip `Pgm` iar rezultatul executiei este ultima stare a 
memoriei. 
Executia unui program se face apeland `pEval`.
-}

import Data.Maybe
import Data.List

newtype EnvState a = EnvState { runEnvState :: Env -> (a, Env) }

instance Monad EnvState where
    return a = EnvState ( \ s -> ( a , s ) )
    ma >>= k = EnvState ( \ state -> 
         let (a , aState ) = runEnvState ma state
         in runEnvState ( k a ) aState )

instance Applicative EnvState where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)

instance Show a => Show (EnvState a) where
  show state =
      let (value, steps) = runEnvState state [("a",3)]
      in "Final: " ++ show value ++ "; Initial: " ++ show steps


instance Functor EnvState where
   fmap f ma = pure f <*> ma

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


getState :: EnvState Env
getState = EnvState ( \ s -> ( s , s ) )

type M a = EnvState a

aEval :: AExp -> Env -> Integer
aEval (Lit x) env = x
aEval (a :+: b) env = aEval a env + aEval b env
aEval (a :*: b) env = aEval a env * aEval b env
aEval (Var n) env = fromJust $ lookup n env

bEval :: BExp -> Env -> Bool
bEval BTrue env = True
bEval BFalse env = False
bEval (a :==: b) env = aEval a env == aEval b env
bEval (Not a) env = not (bEval a env)

sEval :: Stmt -> Env -> Env
sEval Skip env = env
sEval (st1 ::: st2) env = sEval st2 (sEval st1 env)
sEval (If b st1 st2) env =  if bEval b env then sEval st1 env else sEval st2 env
sEval (x := e) env = (x, aEval e env) : filter (\(k,v) -> k /= x) env
sEval (While b s) env
    | not (bEval b env) = env
    | otherwise = sEval (While b s) (sEval s env)

pEval :: Pgm -> Env
pEval (Pgm lvar st) = sEval st [] 

-------------------------------------------------------------------

-- aEvalState :: AExp -> Env -> Integer
-- aEvalState (Lit x) env = x
-- aEvalState (a :+: b) env = aEvalState a env + aEvalState b env
-- aEvalState (a :*: b) env = aEvalState a env * aEvalState b env
-- aEvalState (Var n) env = fromJust $ lookup n env

-- bEvalState :: BExp -> Env -> Bool
-- bEvalState BTrue env = True
-- bEvalState BFalse env = False
-- bEvalState (a :==: b) env = aEvalState a env == aEvalState b env
-- bEvalState (Not a) env = not (bEvalState a env)

sEvalState :: Stmt -> Env -> M Env 
sEvalState Skip env = return env
sEvalState (st1 ::: st2) env = do
    x <- sEvalState st1 env
    sEvalState st2 x
sEvalState (If b st1 st2) env =  if bEval b env then sEvalState st1 env else sEvalState st2 env
sEvalState (x := e) env = return $ (x, aEval e env) : filter (\(k,v) -> k /= x) env
sEvalState (While b s) env
    | not (bEval b env) = return env
    | otherwise = do
        x <- sEvalState s env
        sEvalState (While b s) x
                  
pEvalState :: Pgm -> M Env
pEvalState (Pgm lvar st) = do
    x <- getState
    sEvalState st x

-- pEval :: Pgm -> (Env, Env)
-- pEval (Pgm lvar st) = let stareInitiala = [("n",1)] 
--                     in (stareInitiala, sEval st stareInitiala)



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