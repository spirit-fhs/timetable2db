module ReadFile where
--
import qualified Data.ByteString.Lazy.UTF8 as BSLU
--
readFile :: FilePath -> IO String
readFile filePath = do
 content <- Prelude.readFile filePath
 
-- return $ BSLU.toString content
 return content
--
--
