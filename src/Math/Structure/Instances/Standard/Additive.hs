{-# LANGUAGE
    TemplateHaskell
  , TypeSynonymInstances
  , FlexibleInstances
  #-}

module Math.Structure.Instances.Standard.Additive
where

import Prelude hiding ( (+), (-), negate, subtract )
import qualified Prelude as P

import Math.Structure.Instances.TH.Additive


mkAbeleanGroupInstanceFromNum ''Integer
mkAbeleanGroupInstanceFromNum ''Int

mkAbeleanGroupInstanceFromNum ''Rational
