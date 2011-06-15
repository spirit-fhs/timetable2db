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
   daten <- readFile filePath
   print $ tableList daten
   print "----------------------"
--   print $ convertListToIS $ tableList daten
   printTimeTable $ convertListToIS $ tableList daten
--
--
