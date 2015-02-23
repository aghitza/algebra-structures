{-# LANGUAGE
    FlexibleContexts
  , ConstraintKinds
  , ScopedTypeVariables
  #-}

module Math.Structure.Tasty.Multiplicative where

import Prelude hiding ( (*), (/), recip, (^), (^^) )

import Data.Proxy
import Numeric.Natural ( Natural(..) )
import Test.Tasty
import Test.Natural

import Math.Structure.Multiplicative
import Math.Structure.Multiplicative.Semigroup ( pow1pStd )
import Math.Structure.Multiplicative.Monoid ( pow0pStd )
import Math.Structure.Multiplicative.Group ( powStd )
import Math.Structure.Tasty.Utils


isMultiplicativeSemigroup :: ( Testable a, MultiplicativeSemigroup a )
                          => Proxy a -> TestTree
isMultiplicativeSemigroup p = testGroup "Multiplicative Semigroup" $
  [ isMultiplicativeSemigroup' p ]

isCommutativeSemigroup :: ( Testable a, Commutative a, MultiplicativeSemigroup a )
                   => Proxy a -> TestTree
isCommutativeSemigroup p = testGroup "Multiplicative Commutative Semigroup" $
  [ isCommutative' p
  , isMultiplicativeSemigroup' p
  ]

isMultiplicativeGroup :: ( Testable a, MultiplicativeGroup a )
           => Proxy a -> TestTree
isMultiplicativeGroup p = testGroup "Multiplicative Group" $
  [ isMultiplicativeSemigroup' p
  , isMultiplicativeGroup' p
  ]

isCommutativeGroup :: ( Testable a, Commutative a, MultiplicativeGroup a )
               => Proxy a -> TestTree
isCommutativeGroup p = testGroup "Multiplicative Commutative Group" $
            [ isCommutative' p
            , isMultiplicativeSemigroup' p
            , isMultiplicativeGroup' p
            ]


isCommutative' :: forall a .
              ( Testable a, Commutative a )
           => Proxy a -> TestTree
isCommutative' p = testProperty "Multiplicative Commutative Class" $
                 \a b -> (a::a) * (b::a) == b * a

isMultiplicativeSemigroup' :: forall a .
                ( Testable a, MultiplicativeSemigroup a )
             => Proxy a -> TestTree
isMultiplicativeSemigroup' p = testGroup "Multiplicative Semigroup Class"
  [ testProperty "associative" $
      \a b c -> (a::a) * ((b::a) * (c::a)) == (a * b) * c
  , testProperty "pow1p" $
      \n a ->  pow1p n (a::a) == pow1pStd n a
  ]

isMultiplicativeMonoid' :: forall a .
             ( Testable a, MultiplicativeMonoid a )
          => Proxy a -> TestTree
isMultiplicativeMonoid' p = testGroup "Multiplicative Monoid"
  [ testProperty "one" $
      \a -> (one::a) * (a::a) == a && a * (one::a) == a
  , testProperty "pow0p" $
      \n a ->  pow0p n (a::a) == pow0pStd n a
  , testProperty "(^)" $
      \n a ->  (a::a)^(toInteger (n :: Natural)) == pow0pStd n a
  ]

isMultiplicativeGroup' :: forall a .
            ( Testable a, MultiplicativeGroup a )
         => Proxy a -> TestTree
isMultiplicativeGroup' p = testGroup "Multiplicative Group Class" $
  [ testProperty "recip" $
      \a -> (a::a) * (recip a) == (one::a) && (recip a) * a == (one::a)
  , testProperty "(/)" $
      \a -> (a::a) / a == (one::a)
  , testProperty "pow" $
      \n a ->  pow (n::Integer) (a::a) == powStd n a
  , testProperty "(^^)" $
      \n a ->  (a::a)^^(n :: Integer) == pow n a
  ]