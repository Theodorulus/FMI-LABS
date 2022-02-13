{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie, care au valoarea initiala  0. Interpretarea instructiunilor
este data mai jos. Un program este o expresie de tip Prog, iar rezultatul executiei este starea
finala a memoriei. Testare se face apeland prog test. 
-}

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia If e e1 e2 care evaluează  e1 daca expresia e este nenula si
   e2 in caz contrar.
3) (20pct) Definiti interpretarea  limbajului extins  astfel incat executia unui program  sa calculeze memoria finala,
  si numărul de accesări (scrieri și citiri) ale memoriei Mem2. 
  Rezolvați subiectul 3) în același fișier, redenumind funcțiile de interpretare. 


Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}

data Prog  = On Stmt
data Stmt
    = Off
    | Expr :< Stmt  -- evalueaza Expr, pune rezultatul in Mem1, apoi executa Stmt
    | Expr :<< Stmt -- evalueaza Expr, pune rezultatul in Mem2, apoi executa Stmt
data Mem = Mem1 | Mem2 
data Expr  =  M Mem | V Int | Expr :+ Expr | If Expr Expr Expr

infixl 6 :+
infixr 2 :<
infixr 2 :<<

type Env = (Int,Int)   -- corespunzator celor doua celule de memorie

expr :: Expr -> Env -> Int
expr (M mem) env = case mem of 
    Mem1 -> fst env
    Mem2 -> snd env
expr (V int) env = int
expr (e1 :+ e2) env = expr e1 env + expr e2 env
expr (If cond e1 e2) env = if expr cond env /= 0 then expr e1 env else expr e2 env

stmt :: Stmt -> Env -> Env
stmt Off env = env
stmt (e :< st) env = stmt st (expr e env, snd env)
stmt (e :<< st) env = stmt st (fst env, expr e env)

prog :: Prog -> Env
prog (On st) = stmt st (0,0)


{--
prog test5
(1,0)
prog test6
(2,0)
prog test7
(0,2)
--}
test5 :: Prog
test5 = On (V 5 :< (If (M Mem1) (V 1) (V 2) :< Off))
test6 = On (V 0 :< (If (M Mem1) (V 1) (V 2) :< Off))
test7 = On (V 0 :< (If (M Mem1) (V 1) (V 2) :<< Off))

prog2 :: Prog -> (Env, Int)
prog2 (On st) = stmt2 st (0,0) 0

stmt2 :: Stmt -> Env -> Int -> (Env, Int)
stmt2 Off env cont = (env, cont)
stmt2 (e :< st) env cont = stmt2 st (fst $ expr2 e env cont, snd env) cont
stmt2 (e :<< st) env cont = let (x,y) = expr2 e env cont in stmt2 st (x, snd env) (y+1)

expr2 :: Expr -> Env -> Int -> (Int, Int)
expr2 (M mem) env cont = case mem of
    Mem1 -> (fst env, cont)
    Mem2 -> (snd env, cont+1)
expr2 (V int) env cont = (int, cont)
expr2 (e1 :+ e2) env cont = let (i1, c1) = expr2 e1 env cont
                                (i2, c2) = expr2 e2 env cont in
                                    (i1 + i2, cont + c1 - cont + c2 - cont)
expr2 (If cond e1 e2) env cont = if fst (expr2 cond env cont) /= 0 then expr2 e1 env cont else expr2 e2 env cont


test8 = On (V 0 :<< (If (M Mem1) (V 1) (V 2) :<< Off))
test9 = On (V 3 :<< V 4 :<< M Mem2 :+ M Mem1 :+ (V 5) :<< Off)
test10 = On (V 0 :< (If (M Mem1) (V 1) (V 2) :< Off))