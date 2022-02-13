import Data.Maybe

data Prog = On Instr
data Instr = Off | Expr :> Instr
data Expr = Mem | V Int | Expr :+ Expr
infix 6 :+
type Env = Int -- valoarea celulei de memorie
type DomProg = [Int]
type DomInstr = Env -> [Int]
type DomExpr = Env -> Int


prog :: Prog -> DomProg
prog (On s) = stmt s 0

stmt :: Instr -> DomInstr
stmt (e :> s) m = let v = expr e m in (v : stmt s v)
stmt Off _ = []

expr :: Expr -> DomExpr
expr (a :+ b) mem = expr a mem + expr b mem
expr Mem m = m
expr (V n) _ = n


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
infixl 6 :-:
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
    show (VFun _) = "function"
    show VError = "error"
     
instance Eq Value where
    (VInt a) == (VInt b) = a == b
    (VBool a) == (VBool b) = a == b
    _ == _ = error "trb int/bool"


hEval :: Hask -> DomHask
hEval HTrue env = VBool True 
hEval HFalse env = VBool False
hEval (HLit i) env = VInt i
hEval (HIf h1 h2 h3) env = hif (hEval h1 env) (hEval h2 env) (hEval h3 env) where 
    hif (VBool h1) a b = if h1 then a else b
    hif _ _ _ = VError
hEval (h1 :==: h2) env = heq (hEval h1 env) (hEval h2 env) where
    heq (VInt h1) (VInt h2) = VBool (h1 == h2)
    heq _ _ = VError
hEval (h1 :+: h2) env = hsum (hEval h1 env) (hEval h2 env) where
    hsum (VInt h1) (VInt h2) = VInt (h1 + h2)
    hsum _ _ = VError
hEval (h1 :-: h2) env = hsum (hEval h1 env) (hEval h2 env) where
    hsum (VInt h1) (VInt h2) = VInt (h1 - h2)
    hsum _ _ = VError
hEval (HVar n) env = fromMaybe VError (lookup n env)
hEval (HLam n e) env = VFun (\v -> hEval e ((n, v) : env))
hEval (h1 :$: h2) env = happ (hEval h1 env) (hEval h2 env) where
    happ (VFun f) v = f v
    happ _ _ = VError 

run :: Hask -> String
run pg = show (hEval pg [])
h0 = (HLam "x" (HLam "y" ((HVar "x") :-: (HVar "y"))))
     :$: (HLit 3)
     :$: (HLit 4)
    
-- h1 = HLet "x" (HLit 3) ((HLit 4) :+: HVar "x")