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
         testGroup "HUnit Tests - convertListToIS"
          [ testCase "Test convertListToIS_Test1" test_convertListToIS_Test1
          , testCase "Test convertListToIS_Test2" test_convertListToIS_Test2
          , testCase "Test convertListToIS_Test3" test_convertListToIS_Test3
          ]
        ]
--
--
-- test_rentable = assertBool "moop" ("Hallo" == "Hallo")
--
--
--
test_convertListToIS_Test1 = assertBool "Test1" 
                           ( (convertListToIS [("08.15-09.45", [("Montag", [[" ","Uebung","MMuKS\160V2","PC2\160","g","\160\&2","Brothuhn "]])])] 
                             )
                             == 
                             [Lecture { day = "Montag"
                                      , timeSlot = TimeSlot{ tstart=TimeStamp{hour="08",minute="15"}
                                                           , tend  =TimeStamp{hour="09",minute="45"}
                                                           }
                                      , vtype="Uebung"
                                      , vname="MMuKS\160V2"
                                      , Transformer.IS.location=Transformer.IS.Location{ Transformer.IS.building="F"
                                                                                       , Transformer.IS.room="PC2"}
                                      , week="g"
                                      , group="\160\&2"
                                      , lecturer="Brothuhn"
                                      }
                             ]
                           )
--
test_convertListToIS_Test2 = assertBool "Test2"                   
                           ( (convertListToIS [("08.15-09.45", [("Montag", [[" ","Uebung","MMuKS\160V2","PC2\160","*","\160","g","\160\&2","Brothuhn "]])])] 
                             )
                             == 
                             [Lecture { day = "Montag"
                                      , timeSlot = TimeSlot{ tstart=TimeStamp{hour="08",minute="15"}
                                                           , tend  =TimeStamp{hour="09",minute="45"}
                                                           }
                                      , vtype="Uebung"
                                      , vname="MMuKS\160V2"
                                      , Transformer.IS.location=Transformer.IS.Location{ Transformer.IS.building="F"
                                                                                       , Transformer.IS.room="PC2"}
                                      , week="g"
                                      , group="\160\&2"
                                      , lecturer="Brothuhn"
                                      }
                             ]
                           )
--
test_convertListToIS_Test3 = assertBool "Test3"
                           ( (convertListToIS [("08.15-09.45", [("Montag", [[" ","Uebung","MMuKS\160V2","H0203\160w\160","Brothuhn "]])])]
                             )
                             ==
                             [Lecture { day = "Montag"
                                      , timeSlot = TimeSlot{ tstart=TimeStamp{hour="08",minute="15"}
                                                           , tend  =TimeStamp{hour="09",minute="45"}
                                                           }
                                      , vtype="Uebung"
                                      , vname="MMuKS\160V2"
                                      , Transformer.IS.location=Transformer.IS.Location{ Transformer.IS.building="H"
                                                                                       , Transformer.IS.room="0203"}
                                      , week="w"
                                      , group=""
                                      , lecturer="Brothuhn"
                                      }
                             ]
                           )
--
test_convertListToIS_Test4 = assertBool "Test4"
                           ( (convertListToIS [("08.15-09.45", [("Montag", [[" ","Uebung","MMuKS\160V2","PC2\160","*","\160","g","\160\&2","Brothuhn "]])])]
                             )
                             ==
                             [Lecture { day = "Montag"
                                      , timeSlot = TimeSlot{ tstart=TimeStamp{hour="08",minute="15"}
                                                           , tend  =TimeStamp{hour="09",minute="45"}
                                                           }
                                      , vtype="Uebung"
                                      , vname="MMuKS\160V2"
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
--
