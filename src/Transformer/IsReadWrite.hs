module Transformer.IsReadWrite where
--
--import qualified Transformer.IS as IS
import Transformer.IS
--
--
-- | Funktion zum speichern der Internen Datenstruktur in eine Datei.
saveIStruktur :: FilePath -> TimeTable -> IO ()
saveIStruktur file schedule = do
         writeFile file $ show schedule
--
-- | Funktion zum lesen der Internen Datenstruktur aus einer Datei.
readIStruktur :: FilePath -> IO TimeTable
readIStruktur file = do
          content <- readFile file
          return $ read content
--
