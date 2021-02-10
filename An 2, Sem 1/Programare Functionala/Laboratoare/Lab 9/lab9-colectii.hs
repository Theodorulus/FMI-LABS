type Key = Int
type Value = String

class Collection c where
  cempty :: c 
  csingleton :: Key ->  Value -> c 
  cinsert:: Key -> Value -> c  -> c 
  cdelete :: Key -> c  -> c 
  clookup :: Key -> c -> Maybe Value
  ctoList :: c  -> [(Key, Value)]
  ckeys :: c  -> [Key]
  cvalues :: c  -> [Value]
  cfromList :: [(Key,Value)] -> c
  ckeys a = [fst e | e <- ctoList a]
  cvalues a = [snd e | e <- ctoList a]
  cfromList [] = cempty
  cfromList ((k,v):t) = cinsert k v (cfromList t)

newtype  PairList 
  = PairList { getPairList :: [(Key,Value)] }

instance Show PairList where
     show (PairList l) = "PairList " ++ (show l) 

--

instance Collection PairList where
     cempty = PairList []
     csingleton k v = PairList [(k, v)]
     cdelete k (PairList l) = PairList $ filter ((/=k).fst) l
--
     cinsert k v (PairList l) = PairList $ (k,v):filter ((/=k).fst) l
     --clookup :: Key -> c -> Maybe Value
     --clookup k colectie = (lookup k . getPairList) colectie
     clookup k = lookup k . getPairList
     ctoList = getPairList

--PairList [(3, "d"), (1,"a"), (2, "b")]
--

data SearchTree 
  = Empty
  | Node
      SearchTree  -- elemente cu cheia mai mica 
      Key                    -- cheia elementului
      (Maybe Value)          -- valoarea elementului
      SearchTree  -- elemente cu cheia mai mare
   deriving Show   

instance Collection SearchTree where
     cempty = Empty
     --csingleton :: Key ->  Value -> c
     csingleton k v = Node Empty k (Just v) Empty
     cinsert k v = go
       where
         go Empty = csingleton k v
         go (Node arbst key val arbdr)
            | k == key = Node arbst k (Just v) arbdr
            | k < key = Node (go arbst) key val arbdr
            | otherwise = Node arbst key val (go arbdr)
     cdelete k = go
       where
         go Empty = Empty
         go (Node arbst key val arbdr)
            | k == key = Node arbst k Nothing arbdr
            | k < key = Node (go arbst) key val arbdr
            | otherwise = Node arbst key val (go arbdr)
     ctoList Empty = []
     ctoList (Node arbst key (Just val) arbdr) = (ctoList arbst) ++ [(key, val)] ++ (ctoList arbdr)
     --ctoList
     clookup k = go
       where
         go Empty = Nothing
         go (Node arbst key val arbdr)
            | k == key = val
            | k < key = go arbst
            | otherwise = go arbdr

--Node (Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") Empty) 3 (Just "c") Empty

--Main> cinsert 4 "a" (Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") Empty))
--Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") (Node Empty 4 (Just "a") Empty))

--Main> cinsert 6 "d" (Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") (Node Empty 4 (Just "))
--Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") (Node Empty 4 (Just "a") (Node Empty 6 (Just "d") Empty)))

--Main> cinsert 5 "e" (Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") (Node Empty 4 (Just "))
--Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") (Node Empty 4 (Just "a") (Node (Node Empty 5 (Just "e") Empty) 6 (Just "d") Empty)))

--Main> cdelete 5 (Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") (Node Empty 4 (Just "a") ))
--Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") (Node Empty 4 (Just "a") (Node (Node Empty 5 Nothing Empty) 6 (Just "d") Empty)))

--Main> ctoList (Node (Node Empty 1 (Just "a") Empty) 2 (Just "b") (Node Empty 3 (Just "d") Empty))
--[(1,"a"),(2,"b"),(3,"d")]
