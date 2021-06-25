{-
Gasiti mai jos limbajul unui minicalculator si o interpretare partiala. 
Memoria calculatorului este o stivă de valori (intregi), inițial vidă.
Un program este o listă de instrucțiuni iar rezultatul executiei este starea finală a memoriei.
Testare se face apeland prog test. 
-}

data Prog  = On [Stmt]
data Stmt
  = Push Int -- pune valoare pe stivă    s --> i s
  | Pop      -- elimină valoarea din vărful stivei            i s --> s
  | Plus     -- extrage cele 2 valori din varful stivei, le adună si pune rezultatul inapoi pe stivă i j s --> (i + j) s
  | Dup      -- adaugă pe stivă valoarea din vârful stivei    i s --> i i s
  | Loop [Stmt]

type Env = [Int]   -- corespunzator stivei care conține valorile salvate

stmt :: Stmt -> Env -> Env
stmt (Push x) env = x : env
stmt Pop env = if not (null env) then let (h:t) = env in t else error "stiva este goala"
stmt Plus env = if length env >= 2 then let (h1:h2:t) = env in (h1+h2:t) else 
                    if length env == 1 then env else error "stiva este goala"
stmt Dup env = if length env >= 1 then let (h:t) = env in (h:h:t) else error "stiva este goala"
stmt (Loop l) env = if length env > 1 then stmt (Loop l) (doLoop l env) else env

doLoop :: [Stmt] -> Env -> Env
doLoop [] env = env
doLoop (h:t) env = doLoop t (stmt h env)

stmts :: [Stmt] -> Env -> Env
stmts [] env = env
stmts (h:t) env = stmts t (stmt h env)

prog :: Prog -> Env
prog (On ss) = stmts ss []

test1 = On [Push 3, Push 5, Plus]            -- [8]
test2 = On [Push 3, Dup, Plus]               -- [6]
test3 = On [Push 3, Push 4, Dup, Plus, Plus] -- [11]

test4 = On [Push 3, Push 4, Push 5, Push 6, Loop [Pop]]

test5 = On [Push 3, Push 4, Push 5, Push 6, Pop]

test6 = On [Push 3, Pop, Pop, Push 2]

{-CERINTE

1) (10pct) Finalizati definitia functiilor de interpretare (aruncați excepții dacă stiva nu are suficiente valori pentru o instrucțiune)
2) (10 pct) Adaugati instrucțiunea Loop ss care evaluează repetat lista de instrucțiuni ss 
până când stiva de valori are lungime 1
   -- On [Push 1, Push 2, Push 3, Push 4, Loop [Plus]]  -- [10]
3) (20pct) Modificați interpretarea limbajului extins astfel incat interpretarea unui program /
 instrucțiune / expresie
   să nu mai arunce excepții, ci să aibă tipul rezultat Maybe Env / Maybe Int, 
   unde rezultatul final în cazul în care
   execuția programului încearcă să scoată/acceseze o valoare din stiva de valori vidă va fi Nothing.
   Rezolvați subiectul 3) în același fișier redenumind funcțiile de interpretare.

Indicati testele pe care le-ati folosit in verificarea solutiilor. 
-}

type M a = Maybe a

progM :: Prog -> M Env
progM (On ss) = stmtsM ss []

stmtsM :: [Stmt] -> Env -> M Env
stmtsM [] env = return env
stmtsM (h:t) env = do
    x <- stmtM h env
    stmtsM t x

stmtM :: Stmt -> Env -> M Env
stmtM (Push x) env = return $ x : env
stmtM Pop env = if not (null env) then let (h:t) = env in return t else Nothing 
stmtM Plus env = if length env >= 2 then let (h1:h2:t) = env in return (h1+h2:t) else 
                    if length env == 1 then return env else Nothing
stmtM Dup env = if length env >= 1 then let (h:t) = env in return (h:h:t) else Nothing
stmtM (Loop l) env = if length env > 1 then stmtM (Loop l) (doLoop l env) else return env
