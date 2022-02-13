data Alegere = Piatra | Hartie | Foarfeca
               deriving (Eq, Show)

data Rezultat = Victorie | Infrangere | Egalitate
               deriving (Eq, Show)

partida :: Alegere -> Alegere -> Rezultat
partida arg1 arg2 =  if arg1 == Piatra
                     then if arg2 == Piatra
                          then Egalitate
                          else if arg2 == Hartie
                               then Infrangere
                               else Victorie
                     else if arg1 == Hartie
					      then if arg2 == Hartie
						         then Egalitate
							   else if arg2 == Piatra 
							        then Victorie
									else Infrangere
						  else if arg2 == Foarfeca
						       then Egalitate
							   else if arg2 == Piatra 
							        then Infrangere
									else Victorie