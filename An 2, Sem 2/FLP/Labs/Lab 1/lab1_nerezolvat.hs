import Data.Maybe

data Prog = On Instr
data Instr = Off | Expr :> Instr
data Expr = Mem | V Int | Expr :+ Expr
type Env = Int -- valoarea celulei de memorie
type DomProg = [Int]
type DomInstr = Env -> [Int]
type DomExpr = Env -> Int


prog :: Prog -> DomProg
prog (On s) = stmt s 0

stmt :: Instr -> DomInstr
stmt (expr1 :> instr1) env = let v = expr expr1 env in (v: stmt instr1 v)
stmt Off env = []

expr :: Expr -> DomExpr
expr Mem env = env
expr (V i) env = i
expr (expr1 :+ expr2) env = expr expr1 env + expr expr2 env


p1 = On ( (V 3) :> ((Mem :+ (V 5)):> Off))


type Name = String
data Hask = HTrue
 | HFalse
 | HLit Int
 | HIf Hask Hask Hask
 | Hask :==: Hask
 | Hask :+: Hask
 | Hask :-: Hask
 | HVar Name
 | HLam Name Hask
 | Hask :$: Hask
  deriving (Read, Show)
infix 4 :==:
infixl 6 :+:
infixl 9 :$:

data Value = VBool Bool
 | VInt Int
 | VFun (Value -> Value)
 | VError -- pentru reprezentarea erorilor
type HEnv = [(Name, Value)]

type DomHask = HEnv -> Value

instance Show Value where
  show (VInt i) = show i
  show (VBool b) = show b
  show (VFun _) = "Functie"
  show VError = "Eroare"

instance Eq Value where
  (==) (VInt i) (VInt j) = i == j
  (==) (VBool b1) (VBool b2) = b1 == b2
  (==) _ _ = error "Nu se poate verifica egalitatea"

hEval :: Hask -> DomHask
hEval HTrue env = VBool True

hEval HFalse env = VBool False

hEval (HLit i) env = VInt i

hEval (HIf cond exp_adev exp_fals) env = hif (hEval cond env) (hEval exp_adev env) (hEval exp_fals env) where
   hif (VBool cond) adv fls = if cond then adv else fls
   hif _ _ _ = VError

hEval (exp1 :==: exp2) env = hequal (hEval exp1 env) (hEval exp2 env) where
  --hequal (VBool bool1) (VBool bool2) = if bool1 == bool2 then VBool True else VBool False
  hequal (VInt i) (VInt j) = if i == j then VBool True else VBool False
  hequal _ _ = VError

hEval (exp1 :+: exp2) env = hplus (hEval exp1 env) (hEval exp2 env) where
  hplus (VInt i) (VInt j) = VInt (i + j)
  hplus _ _ = VError

hEval (exp1 :-: exp2) env = hminus (hEval exp1 env) (hEval exp2 env) where
  hminus (VInt i) (VInt j) = VInt (i + j)
  hminus _ _ = VError

hEval (HVar nume) env = fromMaybe VError (lookup nume env)

hEval (HLam nume exp) env = VFun (\v -> hEval exp ((nume, v):env))

hEval (exp1 :$: exp2) env = happly (hEval exp1 env) (hEval exp2 env) where
  happly (VFun f) exp = f exp
  happly _ _ = VError

run :: Hask -> String
run prog = show (hEval prog [])

h0 = (HLam "x" (HLam "y" ((HVar "x") :-: (HVar "y"))))
     :$: (HLit 3)
     :$: (HLit 4)





