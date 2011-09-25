module Main where
--
import HTTPRequest
import HtmlToList
import HtmlToListV2
import Transformer.ListToIS
--
import System.Environment
import Data.ByteString.Lazy (putStrLn, writeFile)
import Data.Aeson.Encode
import qualified Data.Map as M
--
import Transformer.TimeTableToJSONv2
import Transformer.TempEventToJSON
--
import Transformer.IS
import Transformer.IsToEvent
--
-- Libs for working with lecturer database
import Transformer.Lecturer.MultiLecturer
import Transformer.Lecturer.ReadFHSLecturer
import Transformer.TempEvent.TempEventActions
import Transformer.AlternativeRoom.AlternativeRoom
--
--
import Data.List.Split
import RestService

--import System.IO.UTF8 (putStrLn, writeFile)
import Prelude hiding (readFile, writeFile)

import qualified Data.ByteString.Lazy.Char8 as B
import qualified Data.ByteString.Lazy.UTF8 as BSLU
import Data.ByteString.Lazy (unpack, writeFile) 

import Codec.Text.IConv as IConv
--import Data.ByteString.Lazy as ByteString
-- import qualified Data.ByteString.Lazy as L
--
-- filePath = "../vorlage/s_bamm6.html"
-- iconv --from-code=ISO-8859-1 --to-code=UTF-8 s_bamm6.html > s_bamm6_unix.html
--
-- :main "http://sund.de/steffen/plan/s_bai1.html"         -> geht
-- :main "http://sund.de/steffen/plan/s_bai2.html"         -> geht
-- :main "http://sund.de/steffen/plan/s_bai6.html"         -> geht
-- :main "http://sund.de/steffen/plan/s_bamm6.html"        -> geht
-- :main "http://sund.de/steffen/plan/block_sq_bai4.html"  -> geht
-- :main "http://sund.de/steffen/plan/block_sq_bais6.html" -> geht
-- :main "http://sund.de/steffen/plan/block_sq_bawi4.html" -> geht
-- :main "http://sund.de/steffen/plan/block_mps.html"      -> geht
-- :main "http://sund.de/steffen/plan/block_sq_bamm6.html" -> geht
-- :main "http://sund.de/steffen/plan/block_pr_sent.html"
-- :main "http://sund.de/steffen/plan/block_gai.html"
-- :main "http://sund.de/steffen/plan/block_itsuim.html"
--
debug :: Bool
debug = True
outputFile :: Bool
outputFile = True
multiLecturerFile = "MultiLecturer.txt"
fhsDozentJSON     = "mongodb_bkp_fhsdozent.json"
--
-- | The main nedds two files th MultiLecturer.txt and the 
--   mongodb_bkp_fhsdozent.json
--
utf8FromLatin1 = B.unpack . convert "ISO-8859-1" "UTF-8" . B.pack
--
--
--
main = do
   (filePath : args) <- getArgs
--   testTableByFile filePath
--   daten <- readFile filePath
--   daten <- requestHTML filePath
   daten <- fmap (IConv.convert "ISO-8859-1" "UTF-8") (requestHTML filePath)
--   Prelude.putStrLn daten   
--   print $ utf8FromLatin1 "\160"

--   print $ head $ splitOn "." $ (splitOn "_" filePath) !! 1

   if debug == True 
    then
     print $ tableList' $ BSLU.toString daten
    else
     print ""
--   print "----------------------"
--
--  -- | Read Lecturer in Maps and merge it to one
   transDaten   <- readMultiLecturer multiLecturerFile
{-
    where
     multiLecturerFile = 
      if configPath == []
       then
        "MultiLecturer.txt"
       else
        (configPath ++ "MultiLecturer.txt")
-}
   fhsLecturers <- readJSON          fhsDozentJSON
--
-- Check debuging
-- ===============================================
--
   if debug == True
    then
     do
      print ( convertListToIS ( tableList' $ BSLU.toString daten ) )
--      print $ map Transformer.IS.week (convertListToIS $ tableList' daten)
      print $ (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
    else
     print ""
--
-- ===============================================
--
-- When the outputFile are True then the timetable JSON data are write to file.
   if outputFile == True
    then
     Data.ByteString.Lazy.writeFile "event.json" $ encode $
--     System.IO.UTF8.writeFile "event.json" $ BSLU.toString $ encode $
--             convertISToEventS ( convertListToIS $ tableList daten )
             convertISToEventS ( convertListToIS ( tableList' $ BSLU.toString daten ) )
                               2
                               (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                               ("2009-06-24 12:00:00","2009-06-24 13:30:00")
                               "2009-06-24 12:00:00"
    else
     Data.ByteString.Lazy.putStrLn $ encode $ 
--             convertISToEventS ( convertListToIS $ tableList daten ) 
             convertISToEventS ( convertListToIS $ tableList' $ BSLU.toString daten )
                               2 
                               (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                               ("2009-06-24 12:00:00","2009-06-24 13:30:00")
                               "2009-06-24 12:00:00"
--
--
-- Combinate the alternative rooms and the normal time table
--
--
   if ( readAlternativeRoom (BSLU.toString daten) /= [] )
    then 
     do
      print $ roomListToTempEvent $ tail $ tail $ readAlternativeRoom $ BSLU.toString daten
      print $ generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                                 (convertListToIS ( tableList' $ BSLU.toString daten )) 
                                 (roomListToTempEvent $ tail $ tail $ readAlternativeRoom $ BSLU.toString daten)
                                 (head $ splitOn "." $ (splitOn "_" filePath) !! 1)
--
--      Data.ByteString.Lazy.writeFile ((head $ splitOn "." $ (splitOn "_" filePath) !! 1) ++ ".json") $ encode $
--      Data.ByteString.Lazy.writeFile ((head $ splitOn "." $ (splitOn "_" filePath) !! 1) ++ ".json") $ encode $
      writeFile ((head $ splitOn "." $ (splitOn "_" filePath) !! 1) ++ ".json") $ encode $
          generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                             (convertListToIS ( tableList' $ BSLU.toString daten ))
                             (roomListToTempEvent $ tail $ tail $ readAlternativeRoom $ BSLU.toString daten)
                             (head $ splitOn "." $ (splitOn "_" filePath) !! 1)
--       where
--        className = (head $ splitOn "." $ (splitOn "_" filePath) !! 1)

--      print $ M.lookup "braun3" $ M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers)
--      print $ M.lookup ["braun3"] $ M.fromList $ map reverseLecturerTupel $ (M.toList transDaten) ++ (M.toList fhsLecturers)
    else
--     print "Keine Alternativen"
--     Data.ByteString.Lazy.writeFile ((head $ splitOn "." $ (splitOn "_" filePath) !! 1) ++ ".json") $ encode $
     writeFile ((head $ splitOn "." $ (splitOn "_" filePath) !! 1) ++ ".json") $ encode $
        generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                           (convertListToIS ( tableList' $ BSLU.toString daten ))
--                           (roomListToTempEvent $ tail $ tail $ readAlternativeRoom daten)
                           []
                           (head $ splitOn "." $ (splitOn "_" filePath) !! 1)


-- where
--  ( _, _, alternativRooms ) = readAlternativeRoom daten
--   print $ readAlternativeRoom daten
--
-- This write the timetable in a special format in a file for a project from Marcus.
{-
   Data.ByteString.Lazy.writeFile "event.json" $ encode $
            convertISToEventS' ( convertListToIS $ tableList daten )
                               2
                               (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                               ("2009-06-24 12:00:00","2009-06-24 13:30:00")
                               "2009-06-24 12:00:00"
-}

--   print "End"
{-
    where 
     (multiLecturerFile, fhsDozentJSON) =
       if configPath == []
        then
         ("MultiLecturer.txt", "mongodb_bkp_fhsdozent.json")
        else
         ( (configPath ++ "MultiLecturer.txt"), (configPath ++ "mongodb_bkp_fhsdozent.json"))
-}
--
debugConvListToIS url = do
   daten <- requestHTML url
   print $ tableList' $ BSLU.toString daten
   print $ convertListToIS $ tableList' $ BSLU.toString daten

--
{-
test_rentable =  
                           (convertISToEventS [testLecture] 
                                                2 
                                                ( M.fromList [("Braun",["braun"])] )    
                                                ("2009-06-24 12:00:00","2009-06-24 13:30:00")
                                                "2009-06-24 12:00:00"
                           )
  where
   testLecture = Lecture { day="Montag"
                         , timeSlot=TimeSlot{ tstart=TimeStamp{hour="08",minute="15"}
                                            , tend  =TimeStamp{hour="09",minute="45"}
                                            }
                         , vtype="Vorlesung"
                         , vname="SWE Prog V3"
                         , location=Location{building="F",room="004"}
                         , week="Woechentlich"
                         , group=""
                         , lecturer="Braun"
                         }

-}
