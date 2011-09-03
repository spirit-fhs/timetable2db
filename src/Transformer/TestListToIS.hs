module Transformer.TestListToIS where
--
import Test.QuickCheck
--
import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit
--
--
import Transformer.ListToIS
import Transformer.IS
---import qualified Transformer.IS as IS
--import Transformer.IS
--import Transformer.Event.EventS
import qualified Data.Map as M
--
--
main :: IO ()
main = defaultMain tests
--
tests = [
         testGroup "HUnit Tests - One copy"
          [ testCase "Test one" test_convertListToIS
          ]
        ]
--
--
-- test_rentable = assertBool "moop" ("Hallo" == "Hallo")
--
--
--
test_convertListToIS = assertBool "Test convertListToIS test one" 
                           ( (convertListToIS [("08.15-09.45", [("Montag", [[" ","Uebung","MMuKS\160V2","PC2\160","g","\160\&2","Brothuhn "]])])] 
                             )
                             == 
                             [Lecture { day = "Montag"
                                      , timeSlot = TimeSlot{ tstart=TimeStamp{hour="08",minute="15"}
                                                           , tend  =TimeStamp{hour="09",minute="45"}
                                                           }
                                      , vtype="Uebung"
                                      , vname="MMuKS V2"
                                      , Transformer.IS.location=Transformer.IS.Location{ Transformer.IS.building="F"
                                                                                       , Transformer.IS.room="PC2"}
                                      , week="g"
                                      , group="\160\&2"
                                      , lecturer="Brothuhn"
                                      }
                             ]
                           )
--
--
