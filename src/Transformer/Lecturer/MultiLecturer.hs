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
