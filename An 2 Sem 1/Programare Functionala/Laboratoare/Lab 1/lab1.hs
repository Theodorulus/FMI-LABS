
import Data.List

myInt = 5555555555555555555555555555555555555555555555555555555555555555555555555555555555555

double :: Integer -> Integer
double x = x+x

triple :: Integer -> Integer
triple x = 3*x


--maxim :: Integer -> Integer -> Integer
maxim x y = if (x > y)
               then x
          else y

--maxim2 :: Integer -> Integer -> Integer
maxim2::(Integer, Integer) -> Integer
maxim2 (x,y) = if (x > y)
               then x
          else y
 
maxim3::Integer -> Integer -> Integer -> Integer
maxim3 x y z =  if (x > y && x > z)
then x
else if (y > z)
then y
else z

max3 x y z = let
             u = maxim x y
             in (maxim  u z)

maxim4 x y z t = let
				 a = maxim x y
				 b = maxim z t
             in 
				maxim  a b


               
