{-
 Quelle: http://www.ietf.org/rfc/rfc2445.txt

 Packages: Crypto MissingH 

 Examples:
  - All to weeks -> RRULE:FREQ=WEEKLY;INTERVAL=2
  - Every week   -> RRULE:FREQ=WEEKLY
 
 Probleme:
  - 
  - Count weeks for the semester
  - Count the even weeks for the semester
  - Count the odd weeks for the semester

 @TODO:
  - week intervall generation form XXXX/XX/XX to YYYY/YY/YY
-}
module Transformer.TimeTableToICAL where
-- 
--
import Transformer.Event.EventS
import Data.Hash.MD5
import qualified Data.Digest.SHA1 as SHA1
import Data.Time.Calendar
--
{-
 BEGIN:VCALENDAR
VERSION:2.0
PRODID:http://www.example.com/calendarapplication/
METHOD:PUBLISH
BEGIN:VEVENT
UID:461092315540@example.com -- muss eindeutig sein, darf nicht nochmal vorkommen
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
{-
  Berechnung der wochenintervalle fuer ein semester

  Bsp.: 04.10.2011 -> 31.01.2012
-}
-- weekTypeGeneration :: 
weekTypeGeneration = 
  diffDays day2 day1
   where 
    day1 = fromGregorian 2011 10 4
    day2 = fromGregorian 2012 1 31
--
-- testWeekTypeGeneration
--
--
testGen = do
  print $ generateVcal "TEST" icalEvent
  writeFile "test.ics" $ generateVcal "TEST" icalEvent
 where
  icalEvent = 
   [ IcalEvent { uid         = "blabla1@example.com"
               , dtStart     = "20110924T071500Z"
               , dtEnd       = "20110924T084500Z"
               , dtStamp     = "20110906T151152Z"
               , vclass      = "PRIVATE"
               , description = "Test description 1"
               , summary     = "Test title 1"
               }
   , IcalEvent { uid         = "blabla2@example.com"
               , dtStart     = "20110924T090000Z"
               , dtEnd       = "20110924T103000Z"
               , dtStamp     = "20110806T151152Z"
               , vclass      = "PRIVATE"
               , description = "Test description 2"
               , summary     = "Test title 2"
               }
   ]
--  print "End"
--
--
--
--
generateVcal :: String -> IcalEvents -> String
generateVcal calenderName icalEvent = 
    "BEGIN:VCALENDAR" 
 ++ "\n" ++ "VERSION:2.0"
 ++ "\n" ++ "PRODID:http://www.spirit.fh-schmalkalden.de/"
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
