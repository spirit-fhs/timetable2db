module Transformer.IsReadWrite where
--
import qualified Transformer.IS as IS
--
{-
testLayout :: TimeTable
testLayout = [Lecture { day=Montag
                      , timeSlot=TimeSlot{ tstart=TimeStamp{ houre=8
                                                           , minute=15
                                                           }
                                         , tend  =TimeStamp{ houre=9
                                                           , minute=45
                                                           }
                                         }
                      , vtype=Vorlesung
                      , vname="SWE V3"
                      , location=Location{building="H", room="202"}
                      , week=Woechentlich
                      , group=0
                      , lecturer="Braun"
                      }
             ,Lecture { day=Montag
                      , timeSlot=TimeSlot{ tstart=TimeStamp{ houre=8
                                                           , minute=15
                                                           }
                                         , tend  =TimeStamp{ houre=9
                                                           , minute=45
                                                           }
                                         }
                      , vtype=Vorlesung
                      , vname="SWE V3"
                      , location=Location{building="H", room="202"}
                      , week=Woechentlich
                      , group=0
                      , lecturer="Braun"
                      }
             ]
-}
--
-- | Funktion zum speichern der Internen Datenstruktur in eine Datei.
saveIStruktur :: FilePath -> TimeTable -> IO ()
saveIStruktur file schedule = do
         writeFile file $ show schedule
--
-- | Funktion zum lesen der Internen Datenstruktur aus einer Datei.
readIStruktur :: FilePath -> IO TimeTable
readIStruktur file = do
          content <- readFile file
          return $ read content
--
