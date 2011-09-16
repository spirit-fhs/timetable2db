module LoadTimeTables where
--
import HTTPRequest
import HtmlToListV2
import Transformer.ListToIS
--
import Data.ByteString.Lazy (putStrLn, writeFile)
import qualified Data.Map as M
import Data.Aeson.Encode
import System.Directory
import Data.ByteString.UTF8
--import Data.List.Split
--
import Transformer.TempEventToJSON
import Transformer.Lecturer.MultiLecturer
import Transformer.Lecturer.ReadFHSLecturer
import Transformer.TempEvent.TempEventActions
import Transformer.AlternativeRoom.AlternativeRoom
import TempEventUpload
--
{-
spiritdev.fh-schmalkalden.de/news/scheduleapi/fileupload
PUT
content-type : application/json
jeweils nur für einen Studiengang
-}
--
--
multiLecturerFile = "MultiLecturer.txt"
fhsDozentJSON     = "mongodb_bkp_fhsdozent.json"
--
--
testLoadAndUpload =
 do
  existFolder <- doesDirectoryExist "TimeTables"
  if ( existFolder )
   then
    manualTimeTableLoad "TimeTables/"
   else
    do
     createDirectory "TimeTables"
     loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai1.html" "TimeTables/" "Bai1"
--
--loadTimeTables :: IO ()
loadTimeTables = 
 do
  existFolder <- doesDirectoryExist "TimeTables"
  if ( existFolder ) 
   then 
    manualTimeTableLoad "TimeTables/"
   else
    do
     createDirectory "TimeTables"
     manualTimeTableLoad "TimeTables/"
--
manualTimeTableLoad folder =
 do
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai1.html" folder "Bai1"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai2.html" folder "Bai2"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai3.html" folder "Bai3"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai4.html" folder "Bai4"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai5.html" folder "Bai5"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai6.html" folder "Bai6"
--
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bawi1.html" folder "BaWi1"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bawi2.html" folder "BaWi2"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bawi3.html" folder "BaWi3"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bawi4.html" folder "BaWi4"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bawi5.html" folder "BaWi5"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bawi6.html" folder "BaWi6"
--
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bamm1.html" folder "BaMM1"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bamm2.html" folder "BaMM2"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bamm3.html" folder "BaMM3"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bamm4.html" folder "BaMM4"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bamm5.html" folder "BaMM5"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bamm6.html" folder "BaMM6"
--
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_mai1.html" folder "MaI1"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_mai2.html" folder "MaI2"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_mai3.html" folder "MaI3"
--  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_mai4.html" folder "MaI4"
--
-- block events
  loadTimeTableFromWeb "http://sund.de/steffen/plan/block_sq_bai4.html"  folder "sq_Bai4"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/block_itsuim.html"   folder "IS46"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/block_gai.html"      folder "gai_BaWi6"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/block_sq_bamm6.html" folder "sl_BaMM6"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/block_sq_bais6.html" folder "sl_BaIS6"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/block_pr_sent.html"  folder "pr_BaWi5"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/block_mps.html"      folder "ma_BaMM4"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/block_sq_bawi4.html" folder "sl_BaWi4"
--
--loadTimeTableFromWeb :: String -> String -> IO ()
loadTimeTableFromWeb uri timeTableFolder timeTableName = 
 do
  daten        <- requestHTML uri
  transDaten   <- readMultiLecturer multiLecturerFile
  fhsLecturers <- readJSON          fhsDozentJSON
  --
  print $ "Lade: " ++ uri
  --
  print $ tableList' daten
  --
  if ( readAlternativeRoom daten /= [] )
   then
    -- alternative rooms are present
    outputTempEvents transDaten 
                     fhsLecturers 
                     daten 
                     (roomListToTempEvent $ tail $ tail $ readAlternativeRoom daten) 
                     timeTableFolder 
                     timeTableName
   else
    outputTempEvents transDaten fhsLecturers daten [] timeTableFolder timeTableName
--
--
outputTempEvents transDaten fhsLecturers daten alternativRooms timeTableFolder timeTableName = 
 do
  Prelude.putStrLn $
    show $ generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                              (convertListToIS ( tableList' daten ))
                              alternativRooms
                              timeTableName
  Data.ByteString.Lazy.writeFile (timeTableFolder ++ timeTableName ++ ".json") $ encode $
    generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                       (convertListToIS ( tableList' daten ))
                       alternativRooms
                       timeTableName
  -- Upload TempEvent Json
{-
  reqBod <- tempEventUpload "http://spiritdev.fh-schmalkalden.de/news/scheduleapi/fileupload" 
                            $ toString $ encode $
    generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                       (convertListToIS ( tableList' daten ))
                       alternativRooms
                       timeTableName
--  Data.ByteString.Lazy.putStrLn reqBod
  print "--"
-}
