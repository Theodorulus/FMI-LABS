
import Test.QuickCheck
import Test.QuickCheck.Gen



semigroupAssoc :: (Eq m, Semigroup m) => m -> m -> m -> Bool
semigroupAssoc a b c = (a <> (b <> c)) == ((a <> b) <> c)

monoidLeftIdentity   :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty <> a) == a

monoidRightIdentity   :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity a = (a <> mempty) == a

-- Exercițiul 1 - Trivial
 
data Trivial = Trivial
  deriving (Eq, Show)

instance Semigroup Trivial where
  _ <> _ = Trivial

instance Monoid Trivial where
  mempty  = Trivial

instance Arbitrary Trivial where
  arbitrary = elements [Trivial]

type TrivAssoc = Trivial -> Trivial -> Trivial -> Bool
type TrivId    = Trivial -> Bool


test1 = quickCheck (semigroupAssoc :: TrivAssoc)
test2 = quickCheck (monoidLeftIdentity :: TrivId)
test3 = quickCheck (monoidRightIdentity :: TrivId)


 
-- Exercițiul 2 - Conjuncții
 
newtype BoolConj = BoolConj Bool
  deriving (Eq, Show)

instance Semigroup BoolConj where 
    BoolConj a <> BoolConj b = BoolConj (a && b)

instance Monoid BoolConj where 
    mempty = BoolConj True

instance Arbitrary BoolConj where
  --arbitrary = MkGen ( \s i -> BoolConj  ((unGen arbitrary) s i))
  arbitrary = fmap BoolConj arbitrary
  
--      MkGen ( \s i -> BoolConj  (f s i))
--                     where 
--                       f = unGen (arbitrary :: Gen Bool)

                     
type BoolConjAssoc = BoolConj -> BoolConj -> BoolConj -> Bool
type BoolConjId    = BoolConj -> Bool

test4 = quickCheck (semigroupAssoc :: BoolConjAssoc)
test5 = quickCheck (monoidLeftIdentity :: BoolConjId)
test6 = quickCheck (monoidRightIdentity :: BoolConjId)

{-
(BoolConj True <> BoolConj False) <> BoolConj True = BoolConj True <> (BoolConj False <> BoolConj True)
BoolConj (True && False) <> BoolConj True          = BoolConj True <> BoolConj (False && True)
BoolConj False <> BoolConj True                    = BoolConj True <> BoolConj False
BoolConj (False && True)                           = BoolConj (True && False)
BoolConj False                                     = BoolConj False
-}

-- Exercițiul 3 - Disjuncții
 
newtype BoolDisj = BoolDisj Bool
  deriving (Eq, Show)

instance Semigroup BoolDisj where 
   BoolDisj a <> BoolDisj b = BoolDisj (a || b)

instance Monoid BoolDisj where 
   mempty = BoolDisj False

instance Arbitrary BoolDisj where
   --arbitrary =
   arbitrary = fmap BoolDisj arbitrary
  
type BoolDisjAssoc = BoolDisj -> BoolDisj -> BoolDisj -> Bool
type BoolDisjId    = BoolDisj -> Bool


test7 = quickCheck (semigroupAssoc :: BoolDisjAssoc)
test8 = quickCheck (monoidLeftIdentity :: BoolDisjId)
test9 = quickCheck (monoidRightIdentity :: BoolDisjId)


-- Exercițiul 4 - Identity
 
newtype Identity a = Identity a
  deriving (Eq, Show)

instance Semigroup a => Semigroup (Identity a) where
   Identity x <> Identity y = Identity (x <> y)

instance Monoid a => Monoid (Identity a) where
   mempty = Identity mempty

instance Arbitrary a => Arbitrary (Identity a) where
   arbitrary = MkGen ( \s i -> Identity  ((unGen arbitrary) s i))
   
        
type IdentityAssoc a = Identity a -> Identity a -> Identity a -> Bool
type IdentityId    a = Identity a -> Bool


test10 = quickCheck (semigroupAssoc :: IdentityAssoc String)
test11 = quickCheck (monoidLeftIdentity :: IdentityId [Int])
test12 = quickCheck (monoidRightIdentity :: IdentityId [Int])

-- Exercițiul 5 - Pereche
 
data Two a b = Two a b
  deriving (Eq, Show)

instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where --a si b -> tip de date
    Two x y <> Two z t = Two (x <> z) (y <> t) --x, y, z, t -> variabile

instance (Monoid a, Monoid b) => Monoid (Two a b) where --a si b -> tip de date
    mempty = Two mempty mempty

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = MkGen ( \s i -> Two ((unGen (arbitrary)) s i) ((unGen (arbitrary)) s i)) 
  

type TwoAssoc a b = Two a b -> Two a b -> Two a b -> Bool
type TwoId    a b = Two a b -> Bool


test13 = quickCheck (semigroupAssoc :: TwoAssoc String [Int])
test14 = quickCheck (monoidLeftIdentity :: TwoId [Int] String)
test15 = quickCheck (monoidRightIdentity :: TwoId [Int] [Int])


-- Exercițiul 6 - Alternative  


data Or a b = Fst a | Snd b
  deriving (Eq, Show)

instance  Semigroup (Or a b) where 
    Fst _ <> x =  x
    y     <> _ =  y
 
instance (Arbitrary a, Arbitrary b) => Arbitrary (Or a b) where
  arbitrary = oneof [MkGen ( \s i -> Fst  ((unGen arbitrary) s i)),
                     MkGen ( \s i -> Snd  ((unGen arbitrary) s i))]
                     
type OrAssoc a b = Or a b -> Or a b -> Or a b -> Bool
                    

test16 = quickCheck (semigroupAssoc :: OrAssoc String Int)
test17 = quickCheck (semigroupAssoc :: OrAssoc String [Int])






