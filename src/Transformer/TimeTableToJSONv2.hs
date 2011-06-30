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
-- import TestEvents
--
--
--convertISToEventS [Lecture {day="", timeSlot=TimeSlot{tstart=TimeStamp{houre="",minute=""},tend=TimeStamp{houre="",minute=""}}, vtype="", vname="", IS.location=IS.Location{IS.building="",IS.room=""}, week="", group="", lecturer=""}] 2 ["Braun","Hoeller"] ("20...","20....") "20..."
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
--instance ToJSON Member where
--    toJSON (Member member) =
--      object member
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
{-
test1 = do
    Data.ByteString.Lazy.putStrLn $ encode $ testLectur

    Data.ByteString.Lazy.writeFile "event.json" $ encode $ testLectur

  where 
    jsonCode = toJSON testLectur
-}
--
