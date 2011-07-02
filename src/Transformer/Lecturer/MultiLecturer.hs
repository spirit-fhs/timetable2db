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
type Movies = M.Map String [String]
--
test = M.insert "name" ["test"] $ M.empty
--
--
getMapTest = M.lookup "name" test
--
--
writeMap = do
    writeFile "test.txt" $ show $ M.toList test 
    print $ M.toList test
--
--
readMultiLecturer fileName = do
    daten <- readMap fileName
--    print $ M.lookup "name" $ M.fromList daten
    return $ M.fromList daten
--     where
--       myMap = M.fromList daten
--    case M.fromList daten of
--     fromList 
--
--
readMap :: FilePath -> IO [(String,[String])]
--readMap :: M.Map M.Key M.Value
readMap fileName = do
    daten <- readFile fileName
    return $ read daten
--
--
