{-# LANGUAGE OverloadedStrings #-}
--
module Transformer.Lecturer.ReadFHSLecturer where
--
import Data.Aeson
import Data.Aeson.Types ( parseMaybe )
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)
import Data.Attoparsec hiding ( take, takeWhile )
import Data.ByteString.Lazy (ByteString, toChunks, readFile)
import Data.ByteString.Lazy.Internal
-- lines
import Data.ByteString.Lazy.UTF8 (lines)
--
import Transformer.Lecturer.FHSLecturerS
--
--
import qualified Data.Map as M
--
{-
instance ToJSON TypeD where
    toJSON (TypeD name requiredTime hasLectureship) = 
      object [ "name"           .= name
             , "requiredTime"   .= requiredTime
             , "hasLectureship" .= hasLectureship
             ]
--
--
instance ToJSON Dozent where
    toJSON (Dozent name reasonSelfManagement timeSelfManagement typeD) =
      object [ "name"                 .= name
             , "reasonSelfManagement" .= reasonSelfManagement
             , "timeSelfManagement"   .= timeSelfManagement
             , "typeD"                .= typeD
             ]
--
--
instance ToJSON Oid where
    toJSON (Oid oid) =
     object [ "$oid" .= oid ]
--
--
instance ToJSON FHSLecturerS where
    toJSON (FHSLecturerS id fhsId dozent) = 
      object [ "_id"    .= id
             , "fhsId"  .= fhsId
             , "dozent" .= dozent
             ]
-}
--
-- ===========================================================================
--
instance FromJSON TypeD where
    parseJSON (Object v) =
      TypeD <$>
        v .: "name" <*>
        v .: "requiredTime" <*>
        v .: "hasLectureship" 
--
--
instance FromJSON Dozent where
    parseJSON (Object v) =
      Dozent <$>
        v .: "name" <*>
        v .: "reasonSelfManagement" <*>
        v .: "timeSelfManagement" <*>
        v .: "typeD" 
--
--
instance FromJSON Oid where
    parseJSON (Object v) =
      Oid <$>
        v .: "$oid"
--
instance FromJSON FHSLecturerS where
    parseJSON (Object v) =
      FHSLecturerS <$>
        v .: "_id" <*>
        v .: "fhsId" <*>
        v .: "dozent"
    parseJSON _ = mzero
--
--parseingJson :: ByteString -> Maybe FHSLecturerS
--parseingJson :: ByteString -> Maybe Response
parseingJson s =
--   let bs = BS.pack s
--   let bs = pack s
    case parse json s of
      (Done rest r) -> parseMaybe parseJSON r :: Maybe FHSLecturerS
--      (Done rest r) -> parseMaybe parseJSON r :: Maybe Response
--
--
maybeJsonToFHSLecturerS content =
   case content of
    (Just a) -> a
--
--
-- ===========================================================================
--
--
--checkChunk :: ByteString -> ByteString
--
checkChunk elem = 
   case elem of
    Chunk e Empty -> e
--
--checkChunk x e y = e
--test1 = do
--    Data.ByteString.Lazy.putStrLn $ encode $ testLectur
--
--
readJSON = do
     jsonDaten <- Data.ByteString.Lazy.readFile "../daten/mongodb_bkp_fhsdozent.json"
     print "test"
--     print $ map parseingJson (map checkChunk $ Data.ByteString.Lazy.UTF8.lines jsonDaten)
     return $ map maybeJsonToFHSLecturerS $ map parseingJson (map checkChunk $ Data.ByteString.Lazy.UTF8.lines jsonDaten)
--
--
-- filterLecturere = 
     
     
--
--
