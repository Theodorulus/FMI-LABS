{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie. Interpretarea instructiunilor este data mai jos. 


Un program este o expresie de tip Prog, iar rezultatul executiei este starea finala a memoriei
Testare se face apeland prog test. 
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
expr (M Mem1) env = fst env
expr (M Mem2) env = snd env
expr (V i) env = i
expr (e1 :+ e2) env = expr e1 env + expr e2 env
expr (If1 e1 e2) env = if fst env /= 0 then expr e1 env else expr e2 env
expr (If2 e1 e2) env = if snd env /= 0 then expr e1 env else expr e2 env


stmt :: Stmt -> Env -> Env
stmt Off env = env
stmt (e :<< s) env = stmt s (expr e env, snd env)
stmt (e :< s) env = stmt s (fst env, expr e env)


prog :: Prog -> Env
prog (On env s) = stmt s env




test1 = On (1,2) (V 3 :< M Mem1 :+ V 5 :<< Off)
test2 = On (0,0) (V 3 :<< M Mem2 :+ V 5 :< Off)
test3 = On (0,1) (V 3 :<< V 4 :< M Mem1 :+ M Mem2 :+ (V 5) :< Off)
test4 = On (-2,3)(M Mem1  :+  V 3 :< Off)


{-CERINTE


1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresiile If1 e1 e2 si If2 e1 e2  care evaluează  e1 daca Mem1, 
respectiv Mem2, este nenula si e2 in caz contrar.
3) (20pct) Definiti interpretarea  limbajului extins  astfel incat executia unui program  sa calculeze memoria finala,
  si numărul de accesări (scrieri și citiri) ale memoriilor Mem1 si Mem2 (se va calcula o singura
  valoare, insumand accesarile ambelor memorii, fara a lua in considerare initializarea). 
  Rezolvați subiectul 3) în același fișier, redenumind funcțiile de interpretare. 

Indicati testele pe care le-ati folosit in verificarea solutiilor. 
-}

expr1 ::  Expr -> (Env, Int) -> (Int, Int)
expr1 (M Mem1) (env, nr) = (fst env, nr + 1)
expr1 (M Mem2) (env, nr) = (snd env, nr + 1)
expr1 (V i) (env, nr) = (i, nr)
expr1 (e1 :+ e2) (env, nr) = (fst (expr1 e1 (env, nr)) + fst (expr1 e2 (env, nr)), nr)
expr1 (If1 e1 e2) (env, nr) = if fst env /= 0 then expr1 e1 (env, nr + 1) else expr1 e2 (env, nr + 1)
expr1 (If2 e1 e2) (env, nr) = if snd env /= 0 then expr1 e1 (env, nr + 1) else expr1 e2 (env, nr + 1)


stmt1 :: Stmt -> (Env, Int) -> (Env, Int)
stmt1 Off (env, nr) = (env, nr)
stmt1 (e :<< s) (env, nr) = let (f, sc) = expr1 e (env, nr + 1) in  stmt1 s ((f, snd env), sc + 1)
stmt1 (e :< s) (env, nr) = let (f, sc) = expr1 e (env, nr + 1) in stmt1 s ((fst env, f), sc + 1)


prog1 :: Prog -> (Env, Int)
prog1 (On env s) = stmt1 s (env, 0)