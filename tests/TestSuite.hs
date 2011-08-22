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
--
main :: IO ()
main = defaultMain tests
--
tests = [
         testGroup "HUnit Tests - One copy"
          [ testCase "All titles are rentable." test_rentable
          ]
        ]
--
--
-- test_rentable = assertBool "moop" ("Hallo" == "Hallo")
--
--
--
test_rentable = assertBool "moop" 
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

{-
                             [{ "appointment":[]
                              , "degreeClass":[{"class_id":2}]
                              , "eventType":"Lecture"
                              , "expireDate":"2009-06-24 12:00:00"
                              , "member":[{"fhs_id":"recknage"}]
                              ,"titleLong":""
                              ,"titleShort":"Alg/GrMa1V"
                              }
                             ] 
-}
                           )

  where
   testLecture =    Lecture { day="Montag"
                            , timeSlot=TimeSlot{ tstart=TimeStamp{houre="08",minute="15"}
                                               , tend  =TimeStamp{houre="09",minute="45"}
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
