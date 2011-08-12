{-# LANGUAGE OverloadedStrings #-}
--
-- Parse module for the JSON Time Table
--
module ParseTTJson where
--
--
import Data.Aeson
import qualified Data.Aeson.Types as T
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)
import Data.Attoparsec hiding (take, takeWhile)
import Data.Text (Text, pack)
import qualified Data.ByteString.Char8 as BS
--
-- import IS
--
--
--
readJson file = readFile file
--
--
newtype Response = Response { responseJLecture :: [JLecture] }
  deriving (Show)

instance FromJSON Response where
  parseJSON (Object v) =
    Response <$> v .: "lecture"
--
--
--
-- JSON Datenstruktur abbild
data JLecture = JLecture { day      :: String
                         , tstart   :: String
                         , tend     :: String
                         , vType    :: String -- Vorlseung | Uebung
                         , vName    :: String
                         , building :: String
                         , room     :: String
                         , week     :: String -- Gerade | Ungerade | Woechentlich
                         , group    :: Int
                         , lecturer :: String
                         }
    deriving (Show)
--
--
instance FromJSON JLecture where
  parseJSON (Object v) =
    JLecture <$>
       v .: "day" <*>
       v .: "tstart" <*>
       v .: "tend" <*>
       v .: "vType" <*>
       v .: "vName" <*>
       v .: "building" <*>
       v .: "room" <*>
       v .: "week" <*>
       v .: "group" <*>
       v .: "lecturer"
  parseJSON _ = mzero
--
--
parseingJson :: String -> Maybe Response
parseingJson s = 
   let bs = BS.pack s
   in case parse json bs of
      (Done rest r) -> T.parseMaybe parseJSON r :: Maybe Response
--
-- Pruefe ob das parsen erfolgreich war
maybeJsonToJLecture content =
   case content of
    (Just (Response a)) -> a
--     (Just r) -> case r of 
--                  (Response a) -> a
--
--
main = do
     jsonDaten <- readJson "TimeTable.json"
     print jsonDaten
--     parseingJson jsonDaten
--     print $ parseingJson jsonDaten
     print $ maybeJsonToJLecture ( parseingJson jsonDaten ) 
--
--
--
