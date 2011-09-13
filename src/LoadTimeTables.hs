module LoadTimeTables where
--
import HTTPRequest
import HtmlToListV2
import Transformer.ListToIS
import Data.ByteString.Lazy (putStrLn, writeFile)
import qualified Data.Map as M
--import Data.List.Split
--
import Transformer.TempEventToJSON
import Transformer.Lecturer.MultiLecturer
import Transformer.Lecturer.ReadFHSLecturer
import Transformer.TempEvent.TempEventActions
import Transformer.AlternativeRoom.AlternativeRoom
--
{-
spiritdev.fh-schmalkalden.de/news/scheduleapi/fileupload
PUT
content-type : application/json
jeweils nur für einen Studiengang
-}
--
loadTimeTables :: IO ()
loadTimeTables = do
  print $ loadTimeTableFromWeb "http://sund.de/steffen/plan/s_bawi6.html" "BaWi6"
--
--
loadTimeTableFromWeb :: String -> String -> IO ()
loadTimeTableFromWeb uri timeTableName = 
 do
  daten <- requestHTML uri
  transDaten   <- readMultiLecturer multiLecturerFile
  fhsLecturers <- readJSON          fhsDozentJSON
  --
  if ( readAlternativeRoom daten /= [] )
   then
    do
--     print $ roomListToTempEvent $ tail $ tail $ readAlternativeRoom daten
     print $ generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                                (convertListToIS ( tableList' daten ))
                                (roomListToTempEvent $ tail $ tail $ readAlternativeRoom daten)
                                timeTableName
     Data.ByteString.Lazy.writeFile (timeTableName ++ ".json") $ encode $
         generateTempEvents (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                            (convertListToIS ( tableList' daten ))
                            (roomListToTempEvent $ tail $ tail $ readAlternativeRoom daten)
                            timeTableName
--
