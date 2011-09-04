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
tests = [ testGroup "HUnit Tests in TestListToIS - convertListToIS"
          [ testCase "Test convertListToIS_Test1" test_convertListToIS_Test1
          , testCase "Test convertListToIS_Test2" test_convertListToIS_Test2
          , testCase "Test convertListToIS_Test3" test_convertListToIS_Test3
          , testCase "Test convertListToIS_Test4" test_convertListToIS_Test4
          , testCase "Test convertListToIS_Test5" test_convertListToIS_Test5
          ]
        , testGroup "HUnit Tests in TestListToIS - removeSpaceAtEnd"
          [ testCase "Test removeSpaceAtEnd_Test1" test_removeSpaceAtEnd_Test1
          , testCase "Test removeSpaceAtEnd_Test2" test_removeSpaceAtEnd_Test2
          ]
        , testGroup "HUnit Tests in TestListToIS - splitLocationANDWeek"
          [ testCase "Test splitLocationANDWeek_Test1" test_splitLocationANDWeek_Test1
          , testCase "Test splitLocationANDWeek_Test2" test_splitLocationANDWeek_Test2
          ]   
        ]
--
--
-- test_rentable = assertBool "moop" ("Hallo" == "Hallo")
--
--
--
test_convertListToIS_Test1 = assertBool "Test1: Tests (\" \", ivtype, ivname, ilocation, iweek, igroup, ilecturer)" 
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
test_convertListToIS_Test2 = assertBool "Test2: Tests (\" \", ivtype, ivname, ilocation, \"*\", \"\\160\", iweek, igroup, ilecturer)"
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
test_convertListToIS_Test3 = assertBool "Test3: Tests the combination of location and week (H0203\160w\160) room number (\" \", ivtype, ivname, ilocationUiweek, ilecturer)"
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
test_convertListToIS_Test4 = assertBool "Test4: Tests the combination of location and week (PC2\160w\160) room name (\" \", ivtype, ivname, ilocationUiweek, ilecturer)"
                           ( (convertListToIS [("08.15-09.45", [("Montag", [[" ","Uebung","MMuKS\160V2","PC2\160w\160","Brothuhn "]])])]
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
                                      , week="w"
                                      , group=""
                                      , lecturer="Brothuhn"
                                      }
                             ]
                           )
--
--
test_convertListToIS_Test5 = assertBool "Test5: Tests the combination of (ivtype, ivname, ilocation, ilecturer)"
                           ( (convertListToIS [("08.15-09.45", [("Montag", [["Uebung","MMuKS\160V2","H0202\160","Brothuhn "]])])]
                             )
                             ==
                             [Lecture { day = "Montag"
                                      , timeSlot = TimeSlot{ tstart=TimeStamp{hour="08",minute="15"}
                                                           , tend  =TimeStamp{hour="09",minute="45"}
                                                           }
                                      , vtype="Uebung"
                                      , vname="MMuKS\160V2"
                                      , Transformer.IS.location=Transformer.IS.Location{ Transformer.IS.building="H"
                                                                                       , Transformer.IS.room="0202"}
                                      , week=""
                                      , group=""
                                      , lecturer="Brothuhn"
                                      }
                             ]
                           )
--
--
--
test_removeSpaceAtEnd_Test1 = assertBool "Test1: \"H0202 \""
                           ( removeSpaceAtEnd "H0202 "
                           ==
                            "H0202"
                           )
--
test_removeSpaceAtEnd_Test2 = assertBool "Test2: \"H0202\\160\""
                           ( removeSpaceAtEnd "H0202\160"
                           ==
                            "H0202"
                           )
--
--
--
test_splitLocationANDWeek_Test1 = assertBool "Test1: \"H0202\\160w\\160\""
                                   ( splitLocationANDWeek "H0202\160w\160"
                                   ==
                                    ("H0202", 'w')
                                   )
--
test_splitLocationANDWeek_Test2 = assertBool "Test2: \"H0202 w\""
                                   ( splitLocationANDWeek "H0202 w "
                                   ==  
                                    ("H0202", 'w')
                                   )
--
--
