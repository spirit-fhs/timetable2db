module Main where
--
import HtmlToList
import ListToIS
import System.Environment
import Data.ByteString.Lazy (putStrLn)
import Data.Aeson.Encode
--
import TimeTableToJSONv2
--
import IS
import IsToEvent
--
-- filePath = "../vorlage/s_bamm6.html"
--
-- iconv --from-code=ISO-8859-1 --to-code=UTF-8 s_bamm6.html > s_bamm6_unix.html
--
main = do
   (filePath : args) <- getArgs
--   testTableByFile filePath
   daten <- readFile filePath
   print $ tableList daten
   print "----------------------"
--   print $ convertListToIS $ tableList daten
   printTimeTable $ convertListToIS $ tableList daten
--
--
testConverterIsEv = do
--   print lecture
   Data.ByteString.Lazy.putStrLn $ encode $ convertISToEventS [lecture] 
                             2 
                             ["Braun","Knolle","Stiefel"] 
                             ("2009-06-24 12:00:00","2009-06-24 13:30:00") 
                             "2009-06-24 12:00:00"
  where 
   lecture = Lecture {day="", timeSlot=TimeSlot{tstart=TimeStamp{houre="",minute=""},tend=TimeStamp{houre="",minute=""}}, vtype="", vname="", location=Location{building    ="",room=""}, week="", group="", lecturer=""}
--
--
