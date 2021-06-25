data Binar a = Gol | Nod (Binar a) a (Binar a)

exemplu2 :: Binar (Int, Float)
exemplu2 = Nod
            (Nod (Nod Gol (2, 3.5) Gol) (4, 1.2) (Nod Gol (5, 2.4) Gol))
            (7, 1.9)
            (Nod Gol (9, 0.0) Gol)

data Directie = Stanga | Dreapta
type Drum = [Directie]

instance Eq Directie where
    Stanga == Stanga = True
    Dreapta == Dreapta = True
    _ == _ = False

plimbare :: Drum -> Binar (Int,Float) -> Maybe (Int, Float)
plimbare xs Gol = Nothing
plimbare x (Nod a val b)
    | null x = Just val
    | otherwise = let (y:ys) = x in if y == Stanga then plimbare ys a else plimbare ys b

plimbare2 :: Drum -> Binar (Int, Float) -> Maybe (Int, Float)
plimbare2 _ Gol = Nothing
plimbare2 [] (Nod _ x _) = Just x
plimbare2 (Stanga:is) (Nod st _ _) = plimbare is st
plimbare2 (Dreapta:is) (Nod _ _ dr) = plimbare is dr


test211, test212 :: Bool
test211 = plimbare [Stanga, Dreapta] exemplu2 == Just (5, 2.4)
test212 =  plimbare [Dreapta, Stanga] exemplu2 == Nothing 

type Cheie = Int
type Valoare = Float

newtype WriterString a = Writer { runWriter :: (a, String) }
instance Monad WriterString where
    return x = Writer (x, "")
    ma >>= k =
        let (x, logx) = runWriter ma
            (y, logy) = runWriter (k x)
        in Writer (y, logx ++ logy)

tell :: String -> WriterString ()
tell s = Writer ((), s)

instance Functor WriterString where
    fmap f mx = do { f <$> mx ; }

instance Applicative WriterString where
    pure = return
    mf <*> ma = do { f <- mf ; f <$> ma ; }


test221, test222 :: Bool
test221 = runWriter (cauta 5 exemplu2) == (Just 2.4, "Stanga; Dreapta; ")
test222 = runWriter (cauta 8 exemplu2) == (Nothing, "Dreapta; Stanga; ")


cauta :: Cheie -> Binar (Cheie, Valoare) -> WriterString (Maybe Valoare)
cauta x Gol = return Nothing
cauta x (Nod st val dr)
                       | x == v1 = return $ Just v2
                       | x > v1 = tell "Dreapta; " >> cauta x dr
                       | otherwise = tell "Stanga; " >> cauta x st
                        where (v1,v2) = val

cauta2 :: Cheie -> Binar (Cheie, Valoare) -> WriterString (Maybe Valoare)
cauta2 cheie Gol = return Nothing
cauta2 cheie (Nod st (cheie', valoare) dr)
    | cheie == cheie' = return (Just valoare)
    | cheie < cheie' = do
        tell "Stanga; "
        cauta2 cheie st
    | otherwise = do
        tell "Dreapta; "
        cauta2 cheie dr
