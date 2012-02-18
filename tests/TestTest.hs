module Main where
--
-- cabal install QuickCheck test-framework-hunit
--
--import Test.QuickCheck
--import Data.List
--import Control.Monad ( liftM )
import Data.List ( intersperse )
--
import Transformer.ListToIS
import Transformer.IS
--
import Test.QuickCheck
import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.HUnit
--import Test.Framework.Providers.API
import Test.HUnit
--import Test.HUnit.Base
--
import qualified Transformer.TestListToIS as TransTestListToIS
--
--main :: IO ()
--main = defaultMain tests
--
main :: IO ()
--main = defaultMain $ tests
main = defaultMain $ tests ++ TransTestListToIS.tests
--  defaultMain Transformer.TestListToIS.tests
--
tests = [
         testGroup "HUnit Tests - One copy" 
          [ 
            testCase "All titles are rentable." test_rentable
          , testCase "Test locationStringToLocation" test_locationStringToLocation
          , testCase "Standard TimeTable" test_standardTimeTable
          ]
        ]
--
--
test_rentable = assertBool ("Dummy Test") ( "Hallo" == "Hallo" )
--test_rentable = assertBool "moop" ( "Hallo" == "Hollo" )
--
test_locationStringToLocation = assertBool "locationStringToLocation WKST"
                                   ((Location{building="B", room="WKST"}) ==
                                   (locationStringToLocation "WKST"))


test_standardTimeTable = 
  assertBool "Dummy Test 2"
    ( "Hallo" == "Hallo" )

--
--
{-
qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort lhs ++ [x] ++ qsort rhs
    where lhs = filter  (< x) xs
          rhs = filter (>= x) xs
--
--
prop_idempotent xs = qsort (qsort xs) == qsort xs
--
quadraFunc :: Integer -> Integer
quadraFunc x = x * x
--
prop_quadraFunc :: Bool
prop_quadraFunc = quadraFunc 2 == 4
--
--
--
--
prop_PlusAssociative :: Integer -> Integer -> Integer -> Bool
prop_PlusAssociative x y z = 
      (x + y) + z == x + (y + z)

-}
--
