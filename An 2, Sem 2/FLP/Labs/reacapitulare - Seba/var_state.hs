{-
Gasiti mai jos  un minilimbaj. Interpretarea este partial definita.
Un program este o expresie de tip Pgmiar rezultatul executiei este ultima stare a memoriei. 
Executia unui program se face apeland pEval.
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
aEval (Lit x) env = x
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
sEval (st1 ::: st2) env = sEval st2 (sEval st1 env)
sEval (If b st1 st2) env =  if bEval b env then sEval st1 env else sEval st2 env
sEval (x := e) env = (x, aEval e env) : filter (\(k,v) -> k /= x) env
sEval (While b s) env = if bEval b env then sEval (While b s) (sEval s env) else env

pEval :: Pgm -> Env
pEval (Pgm lvar st) = sEval st [(nume, 0) | nume <- lvar]



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
2) (10pct) Adaugati instructiunea While BExp Stmt si interpretarea ei.
3) (20pct) Definiti interpretarea limbajului astfel incat programele sa se execute dintr-o stare 
initiala data iar  pEval  sa afiseze starea initiala si starea finala.

Definiti teste pentru verificarea solutiilor si indicati raspunsurile primite. 

-}


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
      f <$> ma

instance Functor EnvState where
   fmap f ma = f <$> ma

instance Show a => Show (EnvState a) where
  show state =
      let (value, steps) = runEnvState state []
      in "Valoare: " ++ show value ++ "; Starea initiala: " ++ show steps

get :: EnvState Env
get = EnvState ( \ s -> ( s , s ) )

modify :: [Name] -> EnvState ()
modify f = EnvState (const ((), [(nume, 0) | nume <- f]) )

type M a = EnvState a



sEvalM :: Stmt -> Env -> M Env
sEvalM Skip env = return env
sEvalM (st1 ::: st2) env = do
        x <- sEvalM st1 env
        sEvalM st2 x
sEvalM (If b st1 st2) env = if bEval b env then sEvalM st1 env else sEvalM st2 env
sEvalM (x := e) env = return $ (x , aEval e env) : filter (\(k,v) -> k /= x) env
sEvalM (While b s) env = if bEval b env then do
                e <- sEvalM s env
                sEvalM (While b s) e
        else return env


pEvalM :: Pgm -> M Env
pEvalM (Pgm lvar st) = modify lvar >> sEvalM st [(nume, 0) | nume <- lvar]

test2 = Pgm ["n","z"] factStmt