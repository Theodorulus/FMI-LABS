newtype State state a = State { runState :: state -> ( a , state ) }

instance Monad (State state) where 
    return va = State ( \ s -> ( va , s ) )
    ma >>= k = State $ \ s -> let
        ( va , news ) = runState ma s
        in
        runState ( k va ) news

instance Applicative (State state) where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)


instance Functor (State state) where
   fmap f ma = pure f <*> ma

-- instance Show a => Show (State state a) where
--   show state =
--       let (value, steps) = runState state 0
--       in "Value: " ++ show value ++ "; Count: " ++ show steps

get :: State state state
get = State ( \ s -> ( s , s ) )

set :: state -> State state ()
set s = State ( const( ( ) , s ) )

modify :: ( state -> state ) -> State state ( )
modify f = State ( \ s -> ( ( ) , f s ) )

