data Arb = Leaf Integer | Node Arb Arb Arb

data Direction = L | M | R
    deriving Show

type Leafcode = [Direction]

data Writer a = Writer { output :: [Leafcode], value :: a}

instance Monad Writer where
    return x = Writer [] x
    ma >>= k =
        let
            o1 = output ma
            v1 = value ma
            o2 = output (k v1)
            v2 = value (k v1)
        in
            Writer (o1 ++ o2) v2

instance  Applicative Writer where
  pure = return
  mf <*> ma = do
    f <- mf
    f <$> ma

instance  Functor Writer where
  fmap f ma = f <$> ma



tree = Node
          (Node (Leaf 1) (Leaf 3) (Leaf 4))
          (Node (Leaf 1) (Leaf 2) (Leaf 4))
          (Leaf 4)

leafCodes :: Arb -> Integer -> Writer Leafcode
leafCodes (Leaf x) val = return [L]
leafCodes (Node x y z) val = do
        leafCodes x val
        leafCodes y val
        leafCodes z val


leafCodes2 :: Arb -> Integer -> [Direction] -> [Direction]
leafCodes2 (Leaf x) val l
    | x == val = l
    | otherwise = []
leafCodes2 (Node x y z) val l = 
    (leafCodes2 x val (l++[L]) ) ++ ( leafCodes2 y val (l++[M]) ) ++ (leafCodes2 z val (l++[R]) )