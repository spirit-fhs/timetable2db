module Main where
--
import Test.QuickCheck
--
import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit
--
--
import Transformer.IsToEvent
---import qualified Transformer.IS as IS
import Transformer.IS
import Transformer.Event.EventS
import qualified Data.Map as M
--
import qualified Transformer.TestListToIS as TestListToIS
--
main :: IO ()
main = do
   defaultMain (tests ++ TestListToIS.tests)
--   defaultMain TestListToIS.tests
--   print tests
--
tests = [
         testGroup "HUnit Tests TestSuite - convertISToEventS"
          [ testCase "Test test_convertISToEventS_Test1" test_convertISToEventS_Test1
          ]
        ]
--
--
-- test_rentable = assertBool "moop" ("Hallo" == "Hallo")
--
--
--
test_convertISToEventS_Test1 = assertBool "Test1: " 
                           ( (convertISToEventS [testLecture] 
                                                2 
                                                ( M.fromList [("Braun",["braun"])] )
                                                ("2009-06-24 12:00:00","2009-06-24 13:30:00")
                                                "2009-06-24 12:00:00" 
                             )
                             == 
                             [Event { titleShort = "SWE Prog V3"
                                    , titleLong = ""
                                    , expireDate = "2009-06-24 12:00:00"
                                    , eventType = "Lecture"
                                    , degreeClass = [DegreeClass {class_id = 2}]
                                    , member = [FhsID {fhs_id = "braun"}]
                                    , appointment = []
                                    }
                             ]
                           )
  where
   testLecture =    Lecture { day="Montag"
                            , timeSlot=TimeSlot{ tstart=TimeStamp{hour="08",minute="15"}
                                               , tend  =TimeStamp{hour="09",minute="45"}
                                               }
                            , vtype="Vorlesung"
                            , vname="SWE Prog V3"
                            , Transformer.IS.location=Transformer.IS.Location{Transformer.IS.building="F"
                                                                             ,Transformer.IS.room="004"}
                            , week="Woechentlich"
                            , group=""
                            , lecturer="Braun"
                            }
--
--
