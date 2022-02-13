-- NUME: Kaya Adrian, GRUPA: 243

{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie, care au valoarea initiala  0. Interpretarea instructiunilor
este data mai jos. Un program este o expresie de tip `Prog` iar rezultatul executiei este starea
finala a memoriei. Testare se face apeland `prog test`. 
-}

data Prog  = On Stmt                
data Stmt
    = Off
    | Expr :< Stmt  -- evalueaza Expr, pune rezultatul in Mem1, apoi executa Stmt
    | Expr :<< Stmt -- evalueaza Expr, pune rezultatul in Mem2, apoi executa Stmt
    | If Expr Stmt Stmt -- evaluează `e1` daca expresia `e` este nenula si `e2` in caz contrar
data Mem = Mem1 | Mem2 
data Expr  =  M Mem | V Int | Expr :+ Expr

infixl 6 :+
infixr 2 :<
infixr 2 :<<

type Env = (Int, Int)   -- corespunzator celor doua celule de memorie

expr :: Expr -> Env -> (Int, Int)
expr (M Mem1) m = (fst m, 0)
expr (M Mem2) m = (snd m, 1)
expr (V x) _ = (x, 0)
expr (e1 :+ e2) m = (fst (expr e1 m) + fst (expr e2 m), snd (expr e1 m) + snd (expr e2 m))

stmt :: Stmt -> Env -> Int -> Int -> (Env, Int, Int)
stmt Off m scr cit = (m, scr, cit)
stmt (e :< st) m scr cit = stmt st (fst (expr e m), snd m) scr (cit + snd (expr e m))
stmt (e :<< st) m scr cit = stmt st (fst m, fst (expr e m)) (scr + 1) (cit + snd (expr e m))
stmt (If e e1 e2) m scr cit =
    if fst (expr e m) /= 0
    then stmt e1 m scr (cit + snd (expr e m))
    else stmt e2 m scr (cit + snd (expr e m))

prog :: Prog -> (Env, Int, Int)
prog (On s) = stmt s (0, 0) 0 0


test1 = On (V 3 :< M Mem1 :+ V 5 :<< Off) -- (3, 8), 1, 0
test2 = On (V 3 :<< M Mem2 :+ V 5 :< Off) -- (8, 3), 1, 1
test3 = On (V 3 :<< V 4 :< M Mem1 :+ M Mem2 :+ (V 5) :< Off) -- (12, 3), 1, 1
test4 = On (V 3 :+ V 3 :< Off) -- (6, 0), 0, 0
test5 = On (V 3 :+ V 3 :< If (M Mem1) (V 3 :+ V 2 :<< Off) (V 3 :+ V 4 :<< Off)) -- (6, 5), 1, 0
test6 = On (V 3 :+ V 3 :< If (M Mem2) (V 3 :+ V 2 :<< Off) (V 3 :+ V 4 :<< Off)) -- (6, 7), 1, 1

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia `If e e1 e2` care evaluează  `e1` daca expresia `e` este nenula si
   `e2` in caz contrar.
3) (20pct) Definiti interpretarea  limbajului extins  astfel incat executia unui program  sa calculeze memoria finala,
  si numărul de accesări (scrieri și citiri) ale memoriei `Mem2`. 
  Rezolvați subiectul 3) în același fișier, redenumind funcțiile de interpretare. 


Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}