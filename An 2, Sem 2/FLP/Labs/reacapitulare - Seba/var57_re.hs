
{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie, care au valoarea initiala 0. Expresia `Mem := Expr` are urmatoarea semantica: 
`Expr` este evaluata, iar valoarea este pusa in `Mem`.  
Un program este o expresie de tip `Prog`iar rezultatul executiei este dat de valorile finale ale celulelor de memorie.
Testare se face apeland `run test`. 
-}


{-CERINTE
1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia `e1 :/ e2` care evaluează expresiile e1 și e2, apoi
  - dacă valoarea lui e2 e diferită de 0, se evaluează la câtul împărțirii lui e1 la e2;
  - în caz contrar va afișa eroarea "împarțire la 0" și va încheia execuția.
3)(20pct) Definiti interpretarea  limbajului extins astfel incat executia unui program fara erori sa intoarca 
valoarea finala si un mesaj
   care retine toate modificarile celulelor de memorie (pentru fiecare instructiune `m :< v` se adauga 
   mesajul final `Celula m a fost modificata cu valoarea v`), mesajele pastrand ordine de efectuare a
    instructiunilor.  
    Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare. 
Indicati testele pe care le-ati folosit in verificarea solutiilor. 
-}

data Prog
    = Stmt ::: Prog
    | Off

data Stmt
    = Mem := Expr

data Mem
    = Mem1 | Mem2 

data Expr
    = M Mem
    | V Int
    | Expr :+ Expr
    | Expr :/ Expr

infixl 6 :+
infix 3 :=
infixr 2 :::

type Env = (Int,Int)   -- corespunzator celor doua celule de memorie (Mem1, Mem2)


-- Parseaza expresii.
-- Arunca o eroare daca intampina o impartire la 0
expr ::  Expr -> Env -> Int
expr (M m) env = case m of
    Mem1 -> fst env
    Mem2 -> snd env
expr (V int) env = int
expr (e1 :+ e2) env = expr e1 env + expr e2 env
expr (e1 :/ e2) env = let x = expr e2 env in
                        if x /= 0 then expr e1 env `div` x else error "impartire la 0"


stmt :: Stmt -> Env -> Env
stmt (m := e) env = case m of
    Mem1 -> (expr e env, snd env)
    Mem2 -> (fst env, expr e env)

prog :: Prog -> Env -> Env
prog Off env = env
prog (s1 ::: p) env = prog p (stmt s1 env)

run :: Prog -> Env
run p = prog p (0,0)

prg1 = Mem1 := V 3 ::: Mem2 := M Mem1 :+ V 5 ::: Off
prg2 = Mem2 := V 3 ::: Mem1 := V 4 ::: Mem2 := (M Mem1 :+ M Mem2) :+ V 5 ::: Off
prg3 = Mem1 := V 3 :+  V 3 ::: Off
prg4 = Mem1 := V 6 ::: Mem2 := (V 5 :/ V 2) ::: Off

prg5 = Mem1 := V 3 ::: Mem2 := (V 3 :/ V 0) ::: Off

run2 :: Prog -> (Env, String)
run2 p = prog2 p (0,0) ""

prog2 :: Prog -> Env -> String -> (Env, String)
prog2 Off env s = (env, s)
prog2 (s1 ::: p) env s = let (e, st) = stmt2 s1 env s in prog2 p e st

stmt2 :: Stmt -> Env -> String -> (Env, String)
stmt2 (m := e) env st = case m of
    Mem1 -> let val = expr e env in ((val, snd env), st ++ "Celula 1 a fost modificata cu valoarea " ++ show (expr e env) ++ "\n")
    Mem2 -> let val = expr e env in ((fst env, val), st ++ "Celula 2 a fost modificata cu valoarea " ++ show (expr e env) ++ "\n")