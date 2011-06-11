module Main where
--
import HtmlToList
import System.Environment
--
--
main = do
   (filePath : args) <- getArgs
   testTable filePath
--
--
