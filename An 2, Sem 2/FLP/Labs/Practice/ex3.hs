{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Calculatorul are doua celule de memorie, care au valoarea initiala  0.
Instrucțiunea `mem :< expr` are urmatoarea semantica: 
`expr` este evaluata, iar valoarea este pusa in `mem`.  
Un program este o expresie de tip `Prog` care execută pe rănd toate instrucțiunile iar rezultatul executiei
este starea finală a memoriei. 
Testare se face apeland `prog test`. 
-}


data Prog  = On [Stmt]
data Stmt  = Mem :< Expr
data Mem = Mem1 | Mem2 
data Expr = M Mem | V Int | Expr :+ Expr | Expr :/ Expr




infixl 6 :+
infix 4 :<


type Env = (Int,Int)   -- corespunzator celor doua celule de memorie


  
expr ::  Expr -> Env -> Int
expr (e1 :+  e2) (m1, m2) = expr  e1 (m1,m2) + expr  e2 (m1,m2)
expr (M Mem1) env = fst env
expr (M Mem2) env = snd env
expr (V i) env = i
expr (e1 :/ e2) env = let 
        a = expr e1 env
        b = expr e2 env
    in 
        if b /= 0 then
            a `div` b
        else
            error "Impartire la 0"



stmt :: Stmt -> Env -> Env
stmt (Mem1 :< e) env = (expr e env, snd env)
stmt (Mem2 :< e) env = (fst env, expr e env)


stmts :: [Stmt] -> Env -> Env
stmts [] env = env
stmts (h:t) env = stmts t (stmt h env)


prog :: Prog -> Env
prog (On ss) = stmts ss (0, 0)






test1 = On [Mem1 :< V 3, Mem2 :< M Mem1 :+ V 5]
test2 = On [Mem2 :< V 3, Mem1 :< V 4, Mem2 :< (M Mem1 :+ M Mem2) :+ V 5]
test3 = On [Mem2 :< V 3 :+  V 3]

test4 = On [Mem2 :< V 3 :/  V 2]


{-CERINTE


1) (10pct) Finalizati definitia functiilor de interpretare.
2) (10 pct) Adaugati expresia `e1 :/ e2` care evaluează expresiile e1 și e2, apoi
  - dacă valoarea lui e2 e diferită de 0, se evaluează la câtul împărțirii lui e1 la e2;
  - în caz contrar va afișa eroarea "împarțire la 0" și va încheia execuția.
3)(20pct) Definiti interpretarea  limbajului extins astfel incat interpretarea unui program / instrucțiune / expresie
   să aibă tipul rezultat `Either String Env`/ `Either String Int`, unde rezultatul final în cazul în care execuția programului
   întâlnește o împărțire la 0 va fi `Left "împarțire la 0"`.  
   Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare. 




Indicati testele pe care le-ati folosit in verificarea solutiilor. 


-}