module Transformer.TimeTableToICAL where
-- 
--
import Transformer.Event.EventS
import Data.Hash.MD5
import qualified Data.Digest.SHA1 as SHA1
--
{-
 BEGIN:VCALENDAR
VERSION:2.0
PRODID:http://www.example.com/calendarapplication/
METHOD:PUBLISH
BEGIN:VEVENT
UID:461092315540@example.com
ORGANIZER;CN="Alice Balder, Example Inc.":MAILTO:alice@example.com
SUMMARY:Eine Kurzinfo
DESCRIPTION:Beschreibung des Termines
CLASS:PUBLIC
DTSTART:20060910T220000Z
DTEND:20060919T215900Z
DTSTAMP:20060812T125900Z
END:VEVENT
END:VCALENDAR
-}
--
data IcalEvent = 
    IcalEvent { uid         :: String
              , dtStart     :: String
              , dtEnd       :: String
              , dtStamp     :: String
              , vclass      :: String
              , description :: String
              , summary     :: String
              }
--
--
type IcalEvents = [IcalEvent]
--
--
testGen = do
  print $ generateVcal "TEST" icalEvent
  writeFile "test.ics" $ generateVcal "TEST" icalEvent
 where
  icalEvent = 
   [ IcalEvent { uid         = "blabla@example.com"
               , dtStart     = "20110924T080000Z"
               , dtEnd       = "20110924T090000Z"
               , dtStamp     = "20110906T151152Z"
               , vclass      = "PRIVATE"
               , description = "Test description"
               , summary     = "Test summary"
               }
   , IcalEvent { uid         = "blabla@example.com"
               , dtStart     = "20110925T080000Z"
               , dtEnd       = "20110925T090000Z"
               , dtStamp     = "20110806T151152Z"
               , vclass      = "PRIVATE"
               , description = "Test description 2"
               , summary     = "Test summary 2"
               }
   ]
--  print "End"
--
--
generateVcal :: String -> IcalEvents -> String
generateVcal calenderName icalEvent = 
    "BEGIN:VCALENDAR" 
 ++ "\n" ++ "VERSION:2.0"
 ++ "\n" ++ "PRODID:http://www.example.com/calendarapplication/" 
 ++ "\n" ++ "METHOD:PUBLISH"  
 ++ "\n" ++ "X-WR-CALNAME:" ++ calenderName
 ++ "\n" ++ "X-WR-TIMEZONE:Europe/Berlin"
 ++ "\n" ++ "X-WR-CALDESC:"
 ++ "\n" ++ concat (map generateVevent icalEvent)
 ++ "\n" ++ "END:VCALENDAR"
--
--
generateVevent :: IcalEvent -> String
generateVevent icalEvent = 
    "BEGIN:VEVENT"
 ++ "\n" ++ "UID:"         ++ uid         icalEvent
 ++ "\n" ++ "DTSTART:"     ++ dtStart     icalEvent
 ++ "\n" ++ "DTEND:"       ++ dtEnd       icalEvent
 ++ "\n" ++ "DTSTAMP:"     ++ dtStamp     icalEvent
 ++ "\n" ++ "CLASS:"       ++ vclass      icalEvent
 ++ "\n" ++ "DESCRIPTION:" ++ description icalEvent
 ++ "\n" ++ "SUMMARY:"     ++ summary     icalEvent
 ++ "\n" ++ "END:VEVENT" ++ "\n"
--
--
