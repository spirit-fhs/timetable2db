module ReadFile where
--
import qualified Data.ByteString.Lazy.UTF8 as BSLU
import System.IO hiding ( print, writeFile )
--
--readFile :: FilePath -> IO String
readFile :: FilePath -> IO BSLU.ByteString 
readFile filePath = do
-- content <- Prelude.readFile filePath
 fh <- openFile filePath ReadMode
 hSetEncoding fh latin1
 contents <- hGetContents fh
 
 return $ BSLU.fromString contents
-- return contents
--
--
