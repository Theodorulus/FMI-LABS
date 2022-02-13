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
stmt (Put int) env = int : env
stmt Get env = if not (null env) then let (h:t) = env in t else error "eroare"
stmt Max env = if length env >= 2 then let (h1:h2:t) = env in
                        if h1 > h2 then h1:t else h2:t
               else if length env == 1 then env else error "eroare"
stmt Op env = if not (null env) then let (h:t) = env in (-h) : h : t else error "eroare"
stmt (Loop int l) env = if int /= 0 then let e = doLoop l env in stmt (Loop (int-1) l) e else env

doLoop :: [Stmt] -> Env -> Env
doLoop [] env = env 
doLoop (h:t) env = if not (null env) then doLoop t (stmt h env) else error "eroare"

stmts :: [Stmt] -> Env -> Env
stmts [] env = env
stmts (h:t) env = stmts t (stmt h env) 

prog :: Prog -> Env
prog (On ss) = stmts ss []

test1 = On [Put 3, Put 5, Max]            -- [5]
test2 = On [Put (-3), Op, Max]             -- [3]
test3 = On [Put 3, Put (-4), Op, Max, Max] -- [4]
test4 = On [Put 1, Put 2, Put 3, Put 4, Loop 3 [Max]]  -- [4]

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

-- data Either err a = Left err | Right a
-- instance Monad ( Either err ) where
--    return = Right
--    Right va >>= k = k va
--    err >>= _ = err --Left verr >>=_ = Left verr

type M a = Either String a

stmt2 :: Stmt -> Env -> M Env
stmt2 (Put int) env = return (int:env)
stmt2 Get env = if not (null env) then let (h:t) = env in return t else Left $ "eroare"
stmt2 Max env = if length env >= 2 then let (h1:h2:t) = env in
                        if h1 > h2 then return(h1:t) else return(h2:t)
               else if length env == 1 then return env else Left $ "eroare"
stmt2 Op env = if not (null env) then let (h:t) = env in return $ (-h) : h : t else Left $ "eroare"
stmt2 (Loop int l) env = if int /= 0 then let e = doLoop l env in return $ stmt (Loop (int-1) l) e else return env

doLoop2 :: [Stmt] -> Env -> M Env
doLoop2 [] env = return env 
doLoop2 (h:t) env = if not (null env) then return $ doLoop t (stmt h env) else Left $ "eroare"



stmts2 :: [Stmt] -> Env -> M Env
stmts2 [] env = return env
stmts2 (h:t) env = do
   x <- stmt2 h env
   stmts2 t x

prog2 :: Prog -> M Env
prog2 (On ss) = stmts2 ss []

