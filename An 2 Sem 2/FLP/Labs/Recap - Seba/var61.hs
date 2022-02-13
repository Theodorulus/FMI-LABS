{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie. Interpretarea instructiunilor este data mai jos. 

Un program este o expresie de tip `Prog`iar rezultatul executiei este starea finala a memoriei
Testare se face apeland `prog test`. 
-}

type Env = (Int,Int)   -- corespunzator celor doua celule de memorie

data Prog  = On Env Stmt  -- Env reprezinta valorile initiale ale celulelor de memorie                
data Stmt
    = Off
    | Expr :<< Stmt -- evalueaza Expr, pune rezultatul in Mem1, apoi executa Stmt
    | Expr :< Stmt  -- evalueaza Expr, pune rezultatul in Mem2, apoi executa Stmt
data Mem = Mem1 | Mem2 
data Expr  =  M Mem | V Int | Expr :+ Expr | If1 Expr Expr | If2 Expr Expr

infixl 6 :+
infixr 2 :<
infixr 2 :<<



  
expr ::  Expr -> Env -> Int
expr (M m) env = case m of
  Mem1 -> fst env
  Mem2 -> snd env
expr (V x) env = x 
expr (e1 :+  e2) env = expr e1 env + expr e2 env
expr (If1 e1 e2) env = if fst env /= 0 then expr e1 env else expr e2 env
expr (If2 e1 e2) env = if snd env /= 0 then expr e1 env else expr e2 env 


stmt :: Stmt -> Env -> Env
stmt (e :<< st) env = let x = expr e env in stmt st (x, snd env)
stmt (e :< st) env = let x = expr e env in stmt st (fst env, x)
stmt Off m = m

prog :: Prog -> Env
prog (On m s) = stmt s m


test1 = On (1,2) (V 3 :< M Mem1 :+ V 5 :<< Off)
test2 = On (0,0) (V 3 :<< M Mem2 :+ V 5 :< Off)
test3 = On (0,1) (V 3 :<< V 4 :< M Mem1 :+ M Mem2 :+ (V 5) :< Off)
test4 = On (-2,3) (M Mem1  :+  V 3 :< Off)


expr2 :: Expr -> Env -> Int -> (Int, Int)
expr2 (M m) env cont = case m of
  Mem1 -> (fst env, cont+1)
  Mem2 -> (snd env, cont+1)
expr2 (V x) env cont = (x, cont)
expr2 (e1 :+ e2) env cont = let (val1, cont1) = expr2 e1 env cont
                                (val2, cont2) = expr2 e2 env cont in
                                  (val1 + val2, cont + cont1 - cont + cont2 - cont)
expr2 (If1 e1 e2) env cont = if fst env /= 0 then expr2 e1 env cont else expr2 e2 env cont
expr2 (If2 e1 e2) env cont = if snd env /= 0 then expr2 e1 env cont else expr2 e2 env cont

stmt2 :: Stmt -> Env -> Int -> (Env,Int)
stmt2 (e :<< st) env cont = let (x,y) = expr2 e env cont in stmt2 st (x, snd env) (y+1)
stmt2 (e :< st) env cont = let (x,y) = expr2 e env cont in stmt2 st (fst env, x) (y+1)
stmt2 Off m cont = (m,cont)

prog2 :: Prog -> (Env,Int)
prog2 (On m s) = stmt2 s m 0

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresiile `If1 e1 e2` si `If2 e1 e2`  care evaluează  `e1` daca `Mem1`, 
respectiv `Mem2`, este nenula si`e2` in caz contrar.
3) (20pct) Definiti interpretarea  limbajului extins  astfel incat executia unui program  
sa calculeze memoria finala,
  si numărul de accesări (scrieri și citiri) ale memoriilor `Mem1` si `Mem2` (se va calcula o singura
  valoare, insumand accesarile ambelor memorii, fara a lua in considerare initializarea). 
  Rezolvați subiectul 3) în același fișier, redenumind funcțiile de interpretare. 


Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}
