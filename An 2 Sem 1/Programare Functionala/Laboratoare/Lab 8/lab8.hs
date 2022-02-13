import Data.List (nub)
import Data.Maybe (fromJust)


type Nume = String
data Prop
  = Var Nume
  | F
  | T
  | Not Prop
  | Prop :|: Prop
  | Prop :&: Prop
  deriving (Eq, Read)
infixr 2 :|:
infixr 3 :&:

p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not(Var "P") :&: Not(Var "Q"))

p3 :: Prop
p3 = (Var "P" :&: (Var "Q" :|: Var "R")) :&: ((Not(Var "P") :|: Not(Var"Q")) :&: (Not(Var"P") :|: Not(Var "R")))

instance Show Prop where
  show (Var x) = x
  show F = "F"
  show T = "T"
  show (Not prop) = "(~" ++ show prop ++ ")"
  show (prop1 :|: prop2) = "(" ++ show prop1 ++ "|" ++ show prop2 ++ ")"
  show (prop1 :&: prop2) = "(" ++ show prop1 ++ "&" ++ show prop2 ++ ")"

p4 = (Var "P" :|: F) :&: T

test_ShowProp :: Bool
test_ShowProp =
    show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"

par :: String -> String

par p = "(" ++ p ++ ")"

{-

showProp :: Int -> Prop -> String
showProp _ (Var x) = x
showProp _ F = "F"
showProp _ T = "T"

showProp i (Not p) 
  |  i > 1 = par $ "~" ++ showProp 1 p
  | otherwise = "~" ++ showProp 1 p

showProp i (p1 :|: p2) 
  | i > 2 = par $ showProp 2 p1 ++ " | " ++ showProp 2 p2 
  | otherwise = showProp 2 p1 ++ " | " ++ showProp 2 p2 

showProp i (p1 :&: p2) 
  | i > 3 = par $ showProp 3 p1 ++ " & " ++ showProp 3 p2 
  | otherwise = showProp 3 p1 ++ " & " ++ showProp 3 p2 

instance Show Prop where
  show = showProp 0

-}

type Env = [(Nume, Bool)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

eval :: Prop -> Env -> Bool
eval (Var x) env = impureLookup x env
eval (F) _ = False
eval (T) _ = True
eval (Not p) env = not (eval p env)
eval (a :|: b) env = (eval a env) || (eval b env)
eval (a :&: b) env = (eval a env) && (eval b env)
 
test_eval = eval  (Var "P" :|: Var "Q") [("P", True), ("Q", False)] == True

variabile :: Prop -> [Nume]
variabile (Var a) = [a]
variabile T = []
variabile F = []
variabile (Not a) = variabile a
variabile (a :|: b) = nub (variabile a ++ variabile b)
variabile (a :&: b) = nub (variabile a ++ variabile b)
 
test_variabile =
  variabile (Not (Var "P") :&: Var "Q") == ["P", "Q"]


envs :: [Nume] -> [Env]
envs [] = [[]]
envs (x:xs) = [(x, val) :e | val <- [False, True], e <- envs xs]

{-
envs1 :: [Nume] -> [Env]
envs1 [] = []
envs1 [x] = [[x,False], [x,True]]
envs1 (h:t) = let r = envs1 t in map(\x -> (h,False) :x) r ++ map(\x -> (h,True):x) r 
-}
 
test_envs = 
    envs ["P", "Q"]
    ==
    [ [ ("P",False)
      , ("Q",False)
      ]
    , [ ("P",False)
      , ("Q",True)
      ]
    , [ ("P",True)
      , ("Q",False)
      ]
    , [ ("P",True)
      , ("Q",True)
      ]
    ]

satisfiabila1 :: Prop -> [Bool]
satisfiabila1 prop = map (eval prop) (envs( variabile prop ))

satisfiabila :: Prop -> Bool
satisfiabila prop = or (satisfiabila1 prop)


test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q") == True
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P") == False


valida :: Prop -> Bool
valida prop = satisfiabila (Not prop) == False

test_valida1 = valida (Not (Var "P") :&: Var "Q") == False
test_valida2 = valida (Not (Var "P") :|: Var "P") == True

show_Bool :: Bool -> String
show_Bool True = "T"
show_Bool False = "F"

tabelAdevar :: Prop -> String
tabelAdevar p = concat $ map (++ "\n") tabel
         where
           vars = variabile p
           afis_prima = concat $ (map (++ " ") vars) ++ [show p]
           evaluari = envs vars
           aux_af tv= (show_Bool tv) ++ " "
           afis_evaluari ev = concat $ (map aux_af [snd p | p <-ev]) ++ [show_Bool (eval p ev)]
           tabel = afis_prima : (map afis_evaluari evaluari)


--de la profa:

tabelaAdevar1 :: Prop -> IO ()
tabelaAdevar1 = table

centre :: Int -> String -> String
centre w s = replicate h ' ' ++ s ++ replicate (w-n-h) ' '
     where
      n = length s
      h = (w - n) `div` 2

dash :: String -> String
dash s = replicate (length s) '-'

fort :: Bool -> String
fort False = "F"
fort True = "T"

-- Prelude> unlines ["Hello", "World", "!"]
-- "Hello\nWorld\n!\n"
-- Prelude> zipWith (+) [1, 2, 3] [4, 5, 6]
-- [5,7,9]
-- Prelude> unwords ["Lorem", "ipsum", "dolor"]
-- "Lorem ipsum dolor"

showTable :: [[String]] -> IO ()
showTable tab = putStrLn (unlines [ unwords (zipWith centre widths row) | row <- tab ] )
     where
      widths = map length (head tab)

-- Prelude> import Data.List
-- Prelude Data.List> nub [1,2,3,4,3,2,1,2,4,3,5]
-- [1,2,3,4,5]

table p = tables [p]

tables :: [Prop] -> IO ()
tables ps =
     let 
       xs = nub (concatMap variabile ps) 
     in
       showTable ([ xs ++ ["|"] ++ [show p | p <- ps] ] ++
                 [ dashvars xs ++ ["|"] ++ [dash (show p) | p <- ps ] ] ++
                 [ evalvars e xs ++ ["|"] ++ [fort (eval p e) | p <- ps ] | e <- envs xs])
     where 
       dashvars xs = [ dash x | x <- xs ]
       evalvars e xs = [ fort (eval (Var x) e) | x <- xs ]

echivalenta :: Prop -> Prop -> Bool
echivalenta = undefined
 
test_echivalenta1 =
  True
  ==
  (Var "P" :&: Var "Q") `echivalenta` (Not (Not (Var "P") :|: Not (Var "Q")))
test_echivalenta2 =
  False
  ==
  (Var "P") `echivalenta` (Var "Q")
test_echivalenta3 =
  True
  ==
  (Var "R" :|: Not (Var "R")) `echivalenta` (Var "Q" :|: Not (Var "Q"))

