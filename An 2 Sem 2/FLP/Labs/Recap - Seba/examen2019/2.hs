
type Name = String
data Term = Var Name
            | Con Integer
            | Term :+: Term
            | Term :/: Term
            | Lam Name Term
            | App Term Term
            | Out Term
    deriving (Show)

newtype MaybeWriter a = MW { getValue :: Maybe (a, String) }

instance Monad MaybeWriter where
    return a = MW $ Just (a, "")
    ma >>= k =
        case a of
            Nothing -> MW Nothing
            Just (x, w) ->
                case getValue (k x) of
                    Nothing -> MW Nothing
                    Just (y, v) -> MW $ Just (y, w++v)
        where a = getValue ma

instance Applicative MaybeWriter where
    pure = return
    mf <*> ma = do { f <- mf; f <$> ma; }

instance Functor MaybeWriter where
fmap f ma = f <$> ma

type M a = MaybeWriter a


data Value = Num Integer
            | Fun (Value -> M Value)

type Environment = [(Name, Value)]

showM :: Show a => M a -> String
showM ma =
    case a of
        Nothing -> "Nothing"
        Just (a, w) -> "Output: " ++ w ++ "\nValue: " ++ show a
    where a = getValue ma

instance Show Value where
    show (Num x) = show x
    show (Fun _) = "<function>"
--    show Nothing  = "<nothing>"

get :: Name -> Environment -> M Value
get x env = case [v | (y,v) <- env , x == y] of
    (v:_) -> return v
    _ -> MW Nothing

add :: Value -> Value -> M Value
add (Num i) (Num j) = return (Num $ i + j)
add _ _ = MW Nothing

apply :: Value -> Value -> M Value
apply (Fun k) v = k v
apply _ _ = MW Nothing

interp :: Term -> Environment -> M Value
interp (Var x) env = get x env
interp (Con i) _ = return $ Num i
interp (t1 :+: t2) env = do
    v1 <- interp t1 env
    v2 <- interp t2 env
    add v1 v2
interp (t1 :/: t2) env = do
    v1 <- interp t1 env
    v2 <- interp t2 env
    imparte v1 v2
interp (Lam x e) env =
    return $ Fun $ \ v -> interp e ((x,v):env)
interp (App t1 t2) env = do
    f <- interp t1 env
    v <- interp t2 env
    apply f v
interp (Out t) env = do
    v <- interp t env
    tell (show v ++ "; ")
    return v


imparte :: Value -> Value -> M Value
imparte (Num i) (Num j)
    | j == 0 = MW Nothing
    | otherwise = return (Num (i `div` j))
imparte _ _ = MW Nothing

tell :: String -> MaybeWriter ()
tell log = MW $ Just ((), log)

test :: Term -> String
test t = showM $ interp t []

pgm, pgmW :: Term
pgm = App
    (Lam "x" (Var "x" :+: Var "x"))
    (Out (Con 10) :+: Out (Con 11))

pgmW = App (Var "y") (Lam "y" (Out (Con 3)))

pgm2 = App
    (Lam "x" (Var "x" :+: Var "x"))
    (Con 10 :/: Out (Con 2))

pgmW2 = App
    (Lam "x" (Var "x" :+: Var "x"))
    (Con 10 :/: Out (Con 0))