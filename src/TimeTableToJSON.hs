{-# LANGUAGE OverloadedStrings #-}
--
--module ExampleToJSON where
----
----
import Data.Aeson
import Data.Aeson.Types ( parseMaybe )
import Data.Attoparsec.Lazy hiding ( take, takeWhile )
import Control.Applicative ( (<$>), (<*>), pure )
import Data.ByteString.Lazy (ByteString, putStrLn)
--
import IS
--
--data Lecture    = Lecture    { day      :: String   -- ^ day of a week
--                             , timeSlot :: String   -- ^ start and end Time of a schedule
--                             , vtype    :: String   -- ^ describe the type of a schedule (Vorlesung,Uebung)
--                             , vname    :: String   -- ^ the name of the schedule
--                             , location :: String   -- ^ the location of the schedule
--                             , week     :: String   -- ^ describe the week of a schedule (Gerade,Ungerade,Woechentlich)
--                             , group    :: String   -- ^ describe the group of a schedule [1..]
--                             , lecturer :: String   -- ^ describe the dozent name that hold the schedule
--                             }
--                | EmptyLecture
--                             deriving (Show, Read)
--
instance ToJSON TimeStamp where
    toJSON (TimeStamp houre minute) =
      object [ "houre" .= houre, "minute" .= minute]
--
--
instance ToJSON TimeSlot where
    toJSON (TimeSlot tstart tend) =
      object [ "tstart" .= tstart, "tend" .= tend ]
--
--
instance ToJSON Location where
    toJSON (Location building room) =
      object [ "building" .= building, "room" .= room]
--
--
instance ToJSON Lecture where 
    toJSON (Lecture day timeSlot vtype vname location week group lecturer) =
      object [ "day"      .= day
             , "timeSlot" .= timeSlot
             , "vtype"    .= vtype
             , "vname"    .= vname 
             , "location" .= location
             , "week"     .= week
             , "group"    .= group
             , "lecturer" .= lecturer
             ]

--
testLectur :: Lecture
testLectur = Lecture { day = "Dienstag"
                     , timeSlot = TimeSlot{ tstart=TimeStamp{houre="08",minute="15"}
                                          , tend=TimeStamp{houre="09",minute="45"}
                                          }
                     , vtype = "Uebung"
                     , vname = "DBS V2"
                     , location = Location {building = "F", room = "PC3"}
                     , week = "g"
                     , group = "1"
                     , lecturer = "Knolle"
                     }
--
--testLectur :: Lectur
--testLectur = Lecture {day = "Dienstag"
--                     , timeSlot = TimeSlot {tstart = TimeStamp {houre = "17", minute = "45"}
--                                           , tend = TimeStamp {houre = "19", minute = "15"}
--                                           }
--                     , vtype = "Uebung"
--                     , vname = "DBS V2"
--                     , location = Location {building = "B", room = "WKST"}
--                     , week = "g"
--                     , group = " 1"
--                     , lecturer = "Knolle"
--                     }
--
test1 = do
    Data.ByteString.Lazy.putStrLn $ encode $ testLectur
  where 
    jsonCode = toJSON testLectur
--
--
