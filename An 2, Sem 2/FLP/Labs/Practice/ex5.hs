import Data.Either

{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Memoria calculatorului este o stivă de valori (intregi), inițial vidă.
Un program este o listă de instrucțiuni iar rezultatul executiei este starea finală a memoriei.
Testare se face apeland `prog test`. 
-}

data Prog  = On [Stmt]
data Stmt
  = Put Int  -- pune valoare pe stivă    s --> i s
  | Get      -- elimină valoarea din vărful stivei  i s --> s
  | Max      -- extrage cele 2 valori din varful stivei, le compară și pune maximul înapoi pe stivă i j s --> max(i,j) s
  | Op       -- adaugă pe stivă opusul valorii  din vârful stivei    i s --> (-i) i s
  | Loop Int [Stmt]

type Env = [Int]   -- corespunzator stivei care conține valorile salvate

stmt :: Stmt -> Env -> Env
stmt (Put i) env = i : env 
stmt Get env = if not (null env) then tail env else error "Stiva e goala"
stmt Max env 
    | length env >= 2 = let (h1:h2:t) = env in 
            if h1 >= h2 then h1:t
            else h2:t
    | not (null env) = env
    | otherwise = error "Stiva nu are cel putin 2 elemente"
stmt Op env = 
    if not (null env) then negate (head env) : env 
    else error "stiva e goala"
stmt (Loop i ss) env = if i > 0 then
        stmt (Loop (i-1) ss) (stmts ss env)
    else
        env

stmts :: [Stmt] -> Env -> Env
stmts [] env = env
stmts (h:t) env = stmts t (stmt h env)

prog :: Prog -> Env
prog (On ss) = stmts ss [] 

test1 = On [Put 3, Put 5, Max]            -- [5]
test2 = On [Put (-3), Op, Max]             -- [3]
test3 = On [Put 3, Put (-4), Op, Max, Max] -- [4]
test4 = On [Put 1, Put 2, Put 3, Put 4, Loop 2 [Max]]  -- [4]

test5 = On [Put 3, Get, Get]

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare (aruncați excepții dacă stiva nu are suficiente valori pentru o instrucțiune)
2) (10 pct) Adaugati instrucțiunea `Loop n ss` care evaluează de n ori lista de instrucțiuni ss. 
Dacă n=0 nu schimbă nimic, dacă
stiva devine vidă și lista nu se poate evalua de n ori atunci se aruncă excepție.
   -- On [Put 1, Put 2, Put 3, Put 4, Loop 3 [Max]]  -- [4]
3) (20pct) Modificați interpretarea limbajului extins astfel incat interpretarea unui program / instrucțiune /
 expresie
   să nu mai arunce excepții, ci să aibă tipul rezultat `Either String Env` / `Either String Int`, unde rezultatul
    final 
   în cazul în care execuția programului încearcă să scoată/acceseze o valoare din stiva de valori vidă va fi
    `Left "extragere stiva vida"`.
   Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare.    
   
Indicati testele pe care le-ati folosit in verificarea solutiilor. 

-}

stmt1 :: Stmt -> Env -> Either String Env
stmt1 (Put i) env = return (i : env) 
stmt1 Get env = if not (null env) then return (tail env) else Left "extragere stiva vida"
stmt1 Max env 
    | length env >= 2 = let (h1:h2:t) = env in 
            if h1 >= h2 then return (h1:t)
            else return (h2:t)
    | not (null env) = return env
    | otherwise = Left "extragere stiva vida"
stmt1 Op env = 
    if not (null env) then return (negate (head env) : env) 
    else Left "extragere stiva vida"
stmt1 (Loop i ss) env = if i > 0 then
        stmt1 (Loop (i-1) ss) (fromRight [] (stmts1 ss env))
    else
        return env


stmts1 :: [Stmt] -> Env -> Either String Env
stmts1 [] env = return env
stmts1 (h:t) env = return (stmts t (stmt h env))

prog1 :: Prog -> Either String Env
prog1 (On ss) = stmts1 ss [] 