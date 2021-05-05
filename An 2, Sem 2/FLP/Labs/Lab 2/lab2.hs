import Data.Maybe
import Data.List

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
aEval (Lit int) env = int
aEval (exp1 :+: exp2) env = aEval exp1 env + aEval exp2 env
aEval (exp1 :*: exp2) env = aEval exp1 env * aEval exp2 env
aEval (Var name) env = fromMaybe (error "Variabile inexistenta") $ lookup name env

bEval :: BExp -> Env -> Bool
bEval BTrue env = True
bEval BFalse env = False
bEval (exp1 :==: exp2) env = aEval exp1 env == aEval exp2 env
bEval (Not exp) env = not (bEval exp env)

sEval :: Stmt -> Env -> Env
sEval Skip env = env
sEval (s1 ::: s2) env = sEval s2 (sEval s1 env)
sEval (If cond thenBranch elseBranch) env = if (bEval cond env) then (sEval thenBranch env) else (sEval elseBranch env)
sEval (While cond st) env = if (bEval cond env) then (sEval (While cond st) (sEval st env)) else env
sEval (name := exp) env = (name, (aEval exp env)) : filter (\(k,v) -> k /= name) env

pEval :: Pgm -> Env
pEval (Pgm vars st) = sEval st (envFromNames vars)

envFromNames :: [Name] -> Env
envFromNames names = [(name, 0) | name <- names]


factStmt6 =
   "p" := Lit 10 :::
   (If (Not (Var "n" :==: Lit 4))
   ( "p" := Var "p" :*: Var "n" )
   ("n" := Var "n" :+: Lit (-1) )
   )

pg6 = Pgm [] factStmt6



factStmt7 =
   "p" := Lit 10 :::
   (If (Not (Var "n" :==: Lit 4))
   ( "p" := Var "p" :*: Var "n" )
   ("n" := Var "n" :+: Lit (-1) )
   )

pg7 = Pgm ["p", "n"] factStmt7
