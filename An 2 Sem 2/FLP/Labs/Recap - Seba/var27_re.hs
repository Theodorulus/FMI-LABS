{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are o celulă de memorie, care are valoarea initiala  0.
Un program este o expresie de tip `Prog`iar rezultatul executiei este lista valorilor calculate. 
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
expr (V int) env = int
expr (e1 :+ e2) env = expr e1 env + expr e2 env
expr (e1 :* e2) env = expr e1 env * expr e2 env
expr (If e1 e2) env = if env == 0 then expr e1 env else expr e2 env


stmt :: Stmt -> Env -> [Int]
stmt Off env = []
stmt (Save e1 st) env = let x = expr e1 env in x : stmt st x
stmt (NoSave e1 st) env =  let x = expr e1 env in x : stmt st env


prog :: Prog -> [Int]
prog (On st) = stmt st 0


test1 = On (Save (V 3) (NoSave (Mem :+ V 5) Off))
test2 = On (NoSave (V 3 :+  V 3) Off)

test3 = On (Save (V 0) (Save (If (Mem :+ V 5) (Mem :+ V 1)) Off))

expr2 :: Expr -> Env -> Int -> Int -> (Int, Int, Int)
expr2 Mem env adun inmul = (env, adun, inmul)
expr2 (V int) env adun inmul = (int, adun, inmul)
expr2 (e1 :+ e2) env adun inmul = let a = extractFirst $ expr2 e1 env adun inmul
                                      b = extractFirst $ expr2 e2 env adun inmul in
                                          (a+b, adun+1, inmul)
expr2 (e1 :* e2) env adun inmul = let a = extractFirst $ expr2 e1 env adun inmul
                                      b = extractFirst $ expr2 e2 env adun inmul in
                                          (a*b, adun, inmul + 1)
expr2 (If e1 e2) env adun inmul = if env == 0 then expr2 e1 env adun inmul else expr2 e2 env adun inmul

extractFirst :: (a, b, c) -> a
extractFirst (a,_,_) = a



stmt2 :: Stmt -> Env -> Int -> Int -> ([Int], Int, Int)
stmt2 Off env adun inmul = ([], adun, inmul)
stmt2 (Save e1 st) env adun inmul = let (x,ad,inm) = expr2 e1 env adun inmul in (x : extractFirst (stmt2 st x adun inmul), ad, inm)
stmt2 (NoSave e1 st) env adun inmul = let (x,ad,inm) = expr2 e1 env adun inmul in (x : extractFirst (stmt2 st env ad inm), ad, inm)

prog2 :: Prog -> ([Int], Int, Int)
prog2 (On st) = stmt2 st 0 0 0 