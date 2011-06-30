-- Interne Datenstruktur in Json 
-- cabal install JSON
--
import Text.JSON
import IS
--
--
testLayout :: TimeTable
testLayout = [Lecture { day="Montag"
                      , timeSlot=TimeSlot{ tstart=TimeStamp{ houre="8"
                                                           , minute="15"
                                                           }
                                         , tend  =TimeStamp{ houre="9"
                                                           , minute="45"
                                                           }
                                         }
                      , vtype="Vorlesung"
                      , vname="SWE V3"
                      , location=Location{building="H", room="202"}
                      , week="Woechentlich"
                      , group=""
                      , lecturer="Braun"
                      }
             ,Lecture { day="Montag"
                      , timeSlot=TimeSlot{ tstart=TimeStamp{ houre="8"
                                                           , minute="15"
                                                           }
                                         , tend  =TimeStamp{ houre="9"
                                                           , minute="45"
                                                           }
                                         } 
                      , vtype="Vorlesung"
                      , vname="SWE V3"  
                      , location=Location{building="H", room="202"}
                      , week="Woechentlich"
                      , group=""
                      , lecturer="Braun"
                      }      
             ]  
--
--
{-
testJson = readJSON { "news":[{ "id":1, "title":"Heute ist Ausfall", "content":"Heute scheint die Sonne so toll weswegen wir heute keine Vorlesung machen.", "owner":"braun", "displayedName":"Prof. Braun", "classes":[{ "title":"MAI3", "id":2 }], "newsComments":[], "creationDate":"Mon May 09 00:00:00 CEST 2011" }] }"
-}
--
--
{-
{"lecture":[{"day" : "Montag"
            ,"tstart" : "08.15"
            ,"tend" : "09.45"
            ,"vType" : "Vorlesung"
            ,"vName" : "SWE V3"
            ,"building" : "H"
            ,"room" : "202"
            ,"week" : "Gerade"
            ,"group" : 0
            ,"lecturer" : "Braun"
            }
           ,{"day" : "Dienstag"
            ,"tstart" : "08.15"
            ,"tend" : "09.45"
            ,"vType" : "Vorlesung"
            ,"vName" : "SWE V3"
            ,"building" : "H"
            ,"room" : "202"
            ,"week" : "Gerade"
            ,"group" : 0
            ,"lecturer" : "Braun"
            }
           ]
}
-}
--
-- data LectureJson = LectureJson
-- 
testTrans :: TimeTable -> String
testTrans [] = "}"
testTrans (lecture : restTimeTable) = "{\"day\" : \"" ++ day lecture ++ "\""
                                   ++ (testTrans restTimeTable)
--
-- Das entfernen von escape sequenzen bereitet wahrscheinlich probleme
-- Es sollte ein Test gestertet werden ob die escape sequenzen auch wirklich 
-- im sting sind.
--
{-
removeEscape :: String -> String
removeEscape [] = []
removeEscape (x : content) 
        | x == '\' = '|' : removeEscape content
        | otherwise = x : (removeEscape content)
-}
--
-- testTransCall :: String
testTransCall = do
         content <- (testTrans testLayout)
         writeFile "json.txt" content
--         isToJson "json.txt" content           
--         te <- testTrans testLayout
--         return $ read te
--
isToJson :: FilePath -> String -> IO ()
isToJson file content = writeFile file content
--
--
