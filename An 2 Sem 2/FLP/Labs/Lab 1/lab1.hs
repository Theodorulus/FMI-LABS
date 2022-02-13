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
stmt (e :> s) m = let v = expr e m in (v: stmt s v)
stmt Off _ = []

expr :: Expr -> DomExpr
expr Mem env = env
expr (V i) _ = i
expr (ex1 :+ ex2) env = expr ex1 env + expr ex2 env

p1 = On ( (V 3) :> ((Mem :+ (V 5)):> Off))
p2 = On ( (V 5) :> ((Mem :+ (V 4)):> (((Mem :+ (V 3))) :> Off)))


type Name = String
data Hask = 
   HTrue
 | HFalse
 | HLet Name Hask Hask
 | HLit Int
 | HIf Hask Hask Hask
 | Hask :==: Hask
 | Hask :+: Hask
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
     show (VBool val) = show val
     show (VInt val) = show val
     show (VFun _ ) = "functie"
     show (VError) = "eroare"

instance Eq Value where
     (==) (VBool a) (VBool b) = a == b
     (==) (VInt a) (VInt b) = a == b
     (==) _ _ = error ("Nu se poate face egalitatea")


hEval :: Hask -> DomHask
hEval HTrue env = VBool True
hEval HFalse env = VBool False
hEval (HLit i) env = VInt i
hEval (HIf cond adev fals) env = 
    hif (hEval cond env) (hEval adev env) (hEval fals env)
    where hif (VBool b) v w = if b then v else w
          hif _ _ _ = VError

hEval (d :==: e) env = heq (hEval d env) (hEval e env)
    where heq (VInt i) (VInt j) = VBool (i == j)
          heq _ _ = VError

hEval (HVar x) env = fromMaybe VError (lookup x env)

hEval (HLam x e) env = VFun (\v -> hEval e ((x, v):env))

hEval (HLet x ex e) env = hEval e ((x, (hEval ex env)):env)

hEval (d :$: e) env = happ (hEval d env) (hEval e env)
   where happ (VFun f) v = f v
         happ _ _ = VError

run :: Hask -> String
run pg = show (hEval pg [])

h0 = (HLam "x" (HLam "y" ((HVar "x") :+: (HVar "y"))))
      :$: (HLit 3)
      :$: (HLit 4)

h1 = HLet "x" (HLit 3) ((HLit 4) :+: HVar "x")

