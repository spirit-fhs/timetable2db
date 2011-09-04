{-# LANGUAGE OverloadedStrings #-}
--
module Transformer.TimeTableToJSONv2 where
----
----
import Data.Aeson
import Data.Aeson.Types ( parseMaybe )
import Data.Attoparsec.Lazy hiding ( take, takeWhile )
import Control.Applicative ( (<$>), (<*>), pure )
import Data.ByteString.Lazy (ByteString, putStrLn, writeFile)
--
import Transformer.Event.EventS
--
--
instance ToJSON DegreeClass where
    toJSON (DegreeClass class_id) =
      object [ "class_id" .= class_id]
--
--
instance ToJSON FhsID where
    toJSON (FhsID fhs_id) =
      object [ "fhs_id" .= fhs_id ]
--
--
instance ToJSON Location where
    toJSON (Location building room) =
      object [ "building" .= building, "room" .= room]
--
--
instance ToJSON Appointment where
    toJSON (Appointment startAppointment endAppointment status location) =
      object [ "startAppointment" .= startAppointment
             , "endAppointment"   .= endAppointment
             , "status"           .= status
             , "location"         .= location
             ]
--
--
instance ToJSON Event where 
    toJSON (Event titleShort titleLong expireDate eventType degreeClass member appointment) =
      object [ "titleShort"  .= titleShort
             , "titleLong"   .= titleLong
             , "expireDate"  .= expireDate
             , "eventType"   .= eventType
             , "degreeClass" .= degreeClass
             , "member"      .= member
             , "appointment" .= appointment
             ]
--
--
