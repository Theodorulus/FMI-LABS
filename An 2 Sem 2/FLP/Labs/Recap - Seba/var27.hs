{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are o celulă de memorie, care are valoarea initiala  0.
Un program este o expresie de tip `Prog`iar rezultatul executiei este lista valorilor calculate. 
Testare se face apeland `prog test`. 
-}

-- 1 + 2

data Prog  = On Stmt                
data Stmt
   = Off
   | Save Expr Stmt     -- evalueaza expresia și salvează rezultatul in Mem, apoi evalueaza Stmt
   | NoSave Expr Stmt   -- evalueaza expresia, fără a modifica Mem, apoi evaluează Stmt
data Expr  =  Mem | V Int | Expr :+ Expr |  Expr :* Expr | If Expr Expr

infixl 6 :+
infixl 7 :*

type Env = Int   -- valoarea curentă a celulei de memorie

expr :: Expr -> Env -> Int
expr Mem m = m
expr (V x) m = x
expr (e1 :+  e2) m = expr e1 m + expr e2 m
expr (e1 :* e2) m = expr e1 m * expr e2 m
expr (If e1 e2) m = if m == 0 then expr e1 m else expr e2 m

stmt :: Stmt -> Env -> [Int]
stmt Off _ = []
stmt (Save e1 s) m = let v = expr e1 m in (v : stmt s v)
stmt (NoSave e1 s) m = let v = expr e1 m in stmt s m

prog :: Prog -> [Int]
prog (On s) = stmt s 0

test1 = On (Save (V 3) (NoSave (Mem :+ (V 5)) Off))
test2 = On (NoSave (V 3 :+  V 3) Off)

test3 = On (Save (V 0) (Save (If (Mem :+ (V 5)) (Mem :+ (V 1))) Off))

-- 3

newtype State state state2 a = State { runState :: state -> state2 -> ( a , state, state2 ) }

instance Monad (State state state2) where 
    return va = State ( \ s1 s2 -> ( va , s1, s2 ) )
    ma >>= k = State $ \ s1 s2 -> let
        ( va , news , news2) = runState ma s1 s2
        in
        runState ( k va ) news news2

instance Applicative (State state state2) where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)


instance Functor (State state state2) where
   fmap f ma = pure f <*> ma


type M a state1 state2 = State a state1 state2  -- valoarea curentă a celulei de memorie

exprState :: Expr -> Env -> M 
exprState Mem m = m
exprState (V x) m = x
exprState (e1 :+  e2) m = expr e1 m + expr e2 m
exprState (e1 :* e2) m = expr e1 m * expr e2 m
exprState (If e1 e2) m = if m == 0 then expr e1 m else expr e2 m

stmtState :: Stmt -> Env -> M
stmtState Off _ = []
stmtState (Save e1 s) m = let v = expr e1 m in (v : stmt s v)
stmtState (NoSave e1 s) m = let v = expr e1 m in stmt s m

progState :: Prog -> [Int]
progState (On s) = stmt s 0

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia `If e1 e2` care se evaluează `e1` daca `Mem` are valoarea `0` si la `e2` in caz contrar.
3) (20pct)Definiti interpretarea  limbajului extins astfel incat executia unui program sa calculează 
valoarea finala,
numarul de adunari si numarul de inmultiri efectuate.  
Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare.     


Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}