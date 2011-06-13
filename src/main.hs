module Main where
--
import HtmlToList
import ListToIS
import System.Environment
--
--
main = do
   (filePath : args) <- getArgs
--   testTableByFile filePath
   daten <- readL filePath
   print $ tableList daten
   print "----------------------"
   print $ convertListToIS $ tableList daten
--
--
