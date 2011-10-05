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
import Data.ByteString.Lazy.UTF8 (lines, toString, fromString)
--
import Transformer.Lecturer.FHSLecturerS
--
import FileOpp
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
-- ----------------------------------------
--
parseingJson s =
    case parse json s of
      (Done rest r) -> parseMaybe parseJSON r :: Maybe FHSLecturerS
--
-- | This function checks that the JSON read are correct.
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
--
-- | Reads a json file as input an transform it into a Map
readJSON filePath = do
---     jsonDaten <- Data.ByteString.Lazy.readFile filePath
  jsonDaten <- readFileUTF8 filePath
--     jsonDaten <- Prelude.readFile filePath
  return $ M.fromList $ filterLecturere $ map maybeJsonToFHSLecturerS $ map parseingJson (map checkChunk $ Data.ByteString.Lazy.UTF8.lines jsonDaten)
--     return $ M.fromList $ filterLecturere $ map maybeJsonToFHSLecturerS $ map parseingJson (map checkChunk $ Data.ByteString.Lazy.UTF8.lines (fromString jsonDaten))
--
-- | Translate a list of FHSLecturerS into a list of tupls with a key value.
filterLecturere :: [FHSLecturerS] -> [(String,[String])]
filterLecturere [] = []
filterLecturere ( lecturer : lecturers ) = 
--     ((fhsId lecturer), [(name' $ dozent lecturer)] ) : (filterLecturere lecturers)
     ((name' $ dozent lecturer), [(fhsId lecturer)] ) : (filterLecturere lecturers)
--
--
