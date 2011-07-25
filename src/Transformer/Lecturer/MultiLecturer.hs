module Transformer.Lecturer.MultiLecturer where 
--
--
import qualified Data.Map as M
--
--
data MyMap = MyMap [(String,[String])]
      deriving Read
--
--
readMultiLecturer fileName = do
    daten <- readMap fileName
    return $ M.fromList daten
--
--
readMap :: FilePath -> IO [(String,[String])]
readMap fileName = do
    daten <- readFile fileName
    return $ read daten
--
--
