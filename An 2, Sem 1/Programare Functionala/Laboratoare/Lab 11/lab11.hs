import Data.Char
--import Data.Text
import Data.List.Split

prelStr strin = Prelude.map Data.Char.toUpper strin

ioString = do
   strin <- getLine
   putStrLn $ "\nIntrare\n" ++ strin
   let strout = prelStr strin
   putStrLn $ "\nIesire\n" ++ strout


prelNo noin = sqrt noin

ioNumber = do
   noin <- readLn :: IO Double
   putStrLn $ "\nIntrare\n" ++ (show noin)
   let noout = prelNo noin
   putStrLn $ "\nIesire"
   print noout


inoutFile = do
   sin <- readFile "Input.txt"
   putStrLn $ "\nIntrare\n" ++ sin
   let sout = prelStr sin
   putStrLn $ "\nIesire\n" ++ sout
   writeFile "Output.txt" sout


--aux1 :: Int -> [String] -> Int -> IO()
aux1 0 lista _ = do
                     putStrLn $ Prelude.concat $ lista

aux1 m listP ma = do
                     nume <- getLine
                     varsta <- readLn :: IO Int
                     if varsta == ma
                         then aux1 (m - 1) (nume:listP) ma
                         else
                             if varsta > ma
                                 then aux1 (m - 1) [nume] varsta
                                 else aux1 (m - 1) listP ma


ex1 = do
         n <- readLn :: IO Int
         aux1 n [] 0


aux2 :: [String] -> (String, Int)
aux2 [a, b] = (a, read b) -- numele si varsta unei persoane


ex2 = do
         continut <- readFile "ex2.in"
         let listLinii = lines continut -- ["Ion Ionel Ionescu, 70", "Gica Petrescu, 99", "Mustafa ben Muhamad, 7"]
         let persoane = map (\oPers -> aux2(splitOn "," oPers)) listLinii 
		   -- splitOn "," "Ion Ionel Ionescu, 70"
           --aux2["Ion Ionel Ionescu", " 70"] = 
           -- = ("Ion Ionel Ionescu", " 70")
           -- persoane = [("Ion Ionel Ionescu", " 70"), ("Gica Petrescu", 99), ("Mustafa ben Muhamad", 7)]
         let ma = foldr (\(_, b) c -> max b c) 0 persoane
         let listFinala = filter (\(a, b) -> b == ma) persoane
         putStrLn $ concatMap (++ ", ") $ map fst listFinala








