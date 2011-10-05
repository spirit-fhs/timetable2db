module LoadTimeTables where
--
import HTTPRequest
import FileOpp
import HtmlToListV2
import Transformer.ListToIS
--
--import Data.ByteString.Lazy (putStrLn, writeFile)
import qualified Data.Map as M
import Data.Aeson.Encode
import System.Directory
import Data.ByteString.UTF8
--import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy.UTF8 as BSLU
--import Data.List.Split
import Codec.Text.IConv as IConv
import System.IO.UTF8
import System.IO hiding ( print, writeFile )
--                 , IOMode(ReadMode, WriteMode)
--                 )
--import UTF8
--
import Transformer.TempEventToJSON
import Transformer.Lecturer.MultiLecturer
import Transformer.Lecturer.ReadFHSLecturer
import Transformer.TempEvent.TempEventActions
import Transformer.AlternativeRoom.AlternativeRoom
import qualified TempEventUpload as UpTemp
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
--    loadTimeTableFromWeb "http://sund.de/steffen/plan/block_gai.html" "TimeTables/" "test_block"
    loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai1.html" "TimeTables/" "Bai1"
   else
    do
     createDirectory "TimeTables"
--     loadTimeTableFromWeb "http://sund.de/steffen/plan/block_gai.html" "TimeTables/" "test_block"
     loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bai1.html" "TimeTables/" "Bai1"
--
--loadTimeTables :: IO ()
loadTimeTables = 
 do
  existFolder <- doesDirectoryExist "TimeTables"
  if ( existFolder ) 
   then 
    manualTimeTableLoadWeb "TimeTables/"
   else
    do
     createDirectory "TimeTables"
     manualTimeTableLoadWeb "TimeTables/"
--
manualTimeTableLoadFromFiles uriToFiles targetFolder =
 do
  loadTimeTableFromLocal (uriToFiles ++ "s_bai6_unix.html") targetFolder "s_bai6.html"
--
manualTimeTableLoadWeb folder =
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
-- http://sund.de/steffen/plan/s_bais1.html
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bais1.html" folder "BaIS1"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bais2.html" folder "BaIS2"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bais3.html" folder "BaIS3"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bais4.html" folder "BaIS4"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bais5.html" folder "BaIS5"
  loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bais6.html" folder "BaIS6"
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
loadTimeTableFromLocal uri timeTableFolder timeTableName = 
 do 
----  daten <- fmap (IConv.convert "ISO-8859-1" "UTF-8") (ReadFile.readFile uri)
  daten <- FileOpp.readFile uri
--  parseTimeTable (BSLU.fromString daten) timeTableFolder timeTableName
--  parseTimeTable content timeTableFolder timeTableName

  parseTimeTable daten timeTableFolder timeTableName
--  FileOpp.writeFile "tmpPlan.html" $ BSLU.toString daten
  Prelude.print "end"
--
--loadTimeTableFromWeb :: String -> String -> IO ()
loadTimeTableFromWeb uri timeTableFolder timeTableName = 
 do
  daten        <- fmap (IConv.convert "ISO-8859-1" "UTF-8") (requestHTML uri)
--  daten        <- requestHTML uri
  Prelude.print $ "Lade: " ++ uri
  parseTimeTable daten timeTableFolder timeTableName
--
--
parseTimeTable daten timeTableFolder timeTableName =
 do
  transDaten   <- readMultiLecturer multiLecturerFile
  fhsLecturers <- readJSON          fhsDozentJSON
---  Prelude.print $ tableList' $ BSLU.toString daten
  Prelude.print $ "fhsLecture: " ++ (show fhsLecturers)
  if ( readAlternativeRoom (BSLU.toString daten) /= [] )
   then
    outputTempEvents transDaten
                     fhsLecturers
                     (BSLU.toString daten)
                     (roomListToTempEvent $ tail $ tail $ readAlternativeRoom (BSLU.toString daten))
                     timeTableFolder
                     timeTableName
   else
    outputTempEvents transDaten fhsLecturers (BSLU.toString daten) [] timeTableFolder timeTableName
--
--
outputTempEvents transDaten fhsLecturers daten alternativRooms timeTableFolder timeTableName = 
 do
  Prelude.print ( convertListToIS ( tableList' daten ) )

--  Prelude.putStrLn $
  Prelude.print $
    show $ generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                              (convertListToIS ( tableList' daten ))
                              alternativRooms
                              timeTableName
--  Data.ByteString.Lazy.writeFile 
{-
  System.IO.UTF8.writeFile
--  B.writeFileBytes
   (timeTableFolder ++ timeTableName ++ ".json") $ BSLU.toString $ encode $
    generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                       (convertListToIS ( tableList' daten ))
                       alternativRooms
                       timeTableName
-}
  FileOpp.writeFile 
   ( timeTableFolder ++ timeTableName ++ ".json") 
   $ BSLU.toString $ encode $ generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                                                 (convertListToIS ( tableList' daten ))
                                                 alternativRooms
                                                 timeTableName

  -- Upload TempEvent Json

  reqBod <- UpTemp.tempEventUpload "http://spiritdev.fh-schmalkalden.de/news/scheduleapi/fileupload" 
   $ encode $
    generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                       (convertListToIS ( tableList' daten ))
                       alternativRooms
                       timeTableName
--  Data.ByteString.Lazy.putStrLn reqBod
  Prelude.print reqBod

