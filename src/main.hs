module Main where
--
import HtmlToList
import System.Environment
--
--
main = do
   (filePath : args) <- getArgs
--   testTableByFile filePath
   daten <- readL filePath
   print $tableList daten
--
--
