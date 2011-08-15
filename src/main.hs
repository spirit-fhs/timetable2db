module Main where
--
import HTTPRequest
import HtmlToList
import Transformer.ListToIS
--
import System.Environment
import Data.ByteString.Lazy (putStrLn, writeFile)
import Data.Aeson.Encode
import qualified Data.Map as M
--
import Transformer.TimeTableToJSONv2
--
-- import Transformer.IS
import Transformer.IsToEvent
--
-- Libs for working with lecturer database
import Transformer.Lecturer.MultiLecturer
import Transformer.Lecturer.ReadFHSLecturer
--
--
import RestService
-- import qualified Data.ByteString.Lazy as L
--
-- filePath = "../vorlage/s_bamm6.html"
-- iconv --from-code=ISO-8859-1 --to-code=UTF-8 s_bamm6.html > s_bamm6_unix.html
--
-- :main "http://sund.de/steffen/plan/s_bai1.html"  -> geht
-- :main "http://sund.de/steffen/plan/s_bai2.html"  -> geht
-- :main "http://sund.de/steffen/plan/s_bai6.html"  -> geht
-- :main "http://sund.de/steffen/plan/s_bamm6.html" -> geht
--
debug :: Bool
debug = True
outputFile :: Bool
outputFile = True
multiLecturerFile = "MultiLecturer.txt"
fhsDozentJSON     = "../daten/mongodb_bkp_fhsdozent.json"
--
main = do
   (filePath : args) <- getArgs
--   testTableByFile filePath
--   daten <- readFile filePath
   daten <- requestHTML filePath
   if debug == True 
    then
     print $ tableList daten
    else
     print ""
--   print "----------------------"
--
-- ^ Read Lecturer in Maps and merge it to one
   transDaten   <- readMultiLecturer multiLecturerFile
   fhsLecturers <- readJSON          fhsDozentJSON
--
-- Check debuging
-- ===============================================
   if debug == True
    then
     print $ convertListToIS $ tableList daten
    else
     print ""
-- ===============================================
--
-- When the outputFile are True then the timetable JSON data are write to file.
   if outputFile == True
    then
     Data.ByteString.Lazy.writeFile "event.json" $ encode $
             convertISToEventS ( convertListToIS $ tableList daten )
                               2
                               (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                               ("2009-06-24 12:00:00","2009-06-24 13:30:00")
                               "2009-06-24 12:00:00"
    else
     Data.ByteString.Lazy.putStrLn $ encode $ 
             convertISToEventS ( convertListToIS $ tableList daten ) 
                               2 
                               (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                               ("2009-06-24 12:00:00","2009-06-24 13:30:00")
                               "2009-06-24 12:00:00"
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
--
--
