{-# LANGUAGE
    TemplateHaskell
  #-}

module Math.Structure.Instances.TH.Ring
where

import Control.Applicative ( (<$>) )
import Prelude hiding ( (+), (-), negate, subtract
                      , (*), (/), recip, (^), (^^)
                      , gcd
                      , quotRem, quot, rem
                      )
import qualified Prelude as P

import Control.Monad ( sequence, liftM, liftM2 )
import Data.Composition ( (.:) )
import Language.Haskell.TH

import Math.Structure.Additive.DecidableZero
import Math.Structure.Ring
import Math.Structure.Utils.TH


mkSemiringInstance :: Name -> DecsQ
mkSemiringInstance r = sequence
  [ mkInstance' r ''Semiring
  , mkInstance' r ''Distributive
  ]

mkRingInstance :: Name -> DecsQ
mkRingInstance r = concat <$> sequence
  [ mkSemiringInstance r
  , sequence 
    [ mkInstance' r ''Rng
    , mkInstance' r ''Rig
    , mkInstance' r ''Ring
    ]
  ]
  where
  nonzeroR = appT (conT ''NonZero) (conT r)

mkFieldInstance :: Name -> DecsQ
mkFieldInstance r = concat <$> sequence
  [ mkRingInstance r
  , sequence
    [ mkInstance' r ''IntegralDomain
    , mkInstance' r ''DivisionRing
    , mkInstance' r ''Field
    ]
  ]
  where
  nonzeroR = appT (conT ''NonZero) (conT r)

mkEuclideanDomainInstanceFromIntegral :: Name -> DecsQ
mkEuclideanDomainInstanceFromIntegral r =
  liftM mconcat $ sequence
  [ mkRingInstance r
  , mkEuclideanDomainInstanceFromIntegral' r
  ]

mkEuclideanDomainInstanceFromIntegral' :: Name -> DecsQ
mkEuclideanDomainInstanceFromIntegral' r = sequence
  [ mkInstance' r ''IntegralDomain
  , mkInstanceWith' r ''PIDomain
      [ mkDecl 'gcd [| P.gcd |]
      , mkDecl 'xgcd [| head .: euclidean |]
      ]
  , mkInstanceWith' r ''EuclideanDomain
      [ mkDecl 'quotRem [| P.quotRem |]
      , mkDecl 'euclNorm
          [| \a -> if a==0
                   then Nothing
                   else Just $ P.fromIntegral (P.abs a) |]
      ]
  ]
