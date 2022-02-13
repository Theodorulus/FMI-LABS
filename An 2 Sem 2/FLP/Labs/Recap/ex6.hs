{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are o celulă de memorie, care are valoarea initiala  0.
Un program este o expresie de tip `Prog`, iar rezultatul executiei este lista valorilor calculate. 
Testare se face apeland `prog test`. 
-}

-- 1 + 2
{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia `If e1 e2` care se evaluează `e1` daca `Mem` are valoarea `0` si la `e2` 
in caz contrar.
3) (20pct)Definiti interpretarea  limbajului extins astfel incat executia unui program sa calculează 
valoarea finala,
numarul de adunari si numarul de inmultiri efectuate.  
Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare.     


Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}

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
expr Mem env = env
expr (V i) env = i
expr (e1 :+ e2) env = expr e1 env + expr e2 env
expr (e1 :* e2) env = expr e1 env * expr e2 env
expr (If e1 e2) env = if env == 0 then expr e1 env else expr e2 env

stmt :: Stmt -> Env -> [Int]
stmt Off env = []
stmt (Save e s) env = let eval = expr e env in eval : stmt s eval
stmt (NoSave e s) env = let eval = expr e env in eval : stmt s env

prog :: Prog -> [Int]
prog (On s) = stmt s 0

test1 = On (Save (V 3) (NoSave (Mem :+ V 5) Off))
test2 = On (NoSave (V 3 :+  V 3) Off)

test3 = On (Save (V 0) (Save (If (Mem :+ V 5) (Mem :+ V 1)) Off))



get1st (a, _, _) = a
get2nd (_, b, _) = b
get3rd (_, _, c) = c


expr1 :: Expr -> Env -> Int -> Int -> (Int, Int, Int)
expr1 Mem env adun inmult = (env, adun, inmult)
expr1 (V i) env adun inmult = (i, adun, inmult)
expr1 (e1 :+ e2) env adun inmult = let 
    (a1, b1, c1) = expr1 e1 env adun inmult
    (a2, b2, c2) = expr1 e2 env adun inmult
    in
    (a1 + a2, adun + b1 - adun + b2 - adun + 1, inmult + c1 - inmult + c2 - inmult)
expr1 (e1 :* e2) env adun inmult = let 
    (a1, b1, c1) = expr1 e1 env adun inmult
    (a2, b2, c2) = expr1 e2 env adun inmult
    in
    (a1 + a2, adun + b1 - adun + b2 - adun, inmult + c1 - inmult + c2 - inmult + 1)
expr1 (If e1 e2) env adun inmult = if env == 0 then expr1 e1 env adun inmult else expr1 e2 env adun inmult

stmt1 :: Stmt -> Env -> Int -> Int -> ([Int], Int, Int)
stmt1 Off env adun inmult = ([], adun, inmult)
stmt1 (Save e s) env adun inmult = let (a, b, c) = expr1 e env adun inmult in (a : get1st (stmt1 s a adun inmult), b, c)
stmt1 (NoSave e s) env adun inmult = let (a, b, c) = expr1 e env adun inmult in (a : get1st (stmt1 s env adun inmult), b, c)

prog1 :: Prog -> ([Int], Int, Int)
prog1 (On s) = stmt1 s 0 0 0

