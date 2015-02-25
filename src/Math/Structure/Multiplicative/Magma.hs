{-# LANGUAGE
    StandaloneDeriving
  , GeneralizedNewtypeDeriving
  #-}

module Math.Structure.Multiplicative.Magma
where

import Prelude hiding ( (*), (/), recip, (^), (^^) )

import Math.Structure.Additive.DecidableZero


infixl 7 *

class MultiplicativeMagma a where
  (*) :: a -> a -> a

deriving instance    MultiplicativeMagma a
                  => MultiplicativeMagma (NonZero a)
