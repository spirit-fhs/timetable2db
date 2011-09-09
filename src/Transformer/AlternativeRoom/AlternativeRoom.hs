module Transformer.AlternativeRoom.AlternativeRoom where
-- 
--
import Text.HTML.TagSoup
import Data.List.Split
--
--
import qualified Transformer.ListToIS as ListToIS
import qualified Transformer.IS as IS
--
--
data Place           = 
  Place       { building       :: String
              , room           :: String
              }   
              deriving (Show, Read)
--
data AlternativeRoom = 
  AlternativeRoom { day        :: String
                  , week       :: String
                  , state      :: String
                  , location   :: IS.Location
                  , lecture    :: String
                  , aType      :: String
                  }
                  deriving (Show, Read)
--
--
roomListToTempEvent [] = []
roomListToTempEvent (alternative : listRooms) = splitAlternativeList alternative : (roomListToTempEvent listRooms)
--
--
splitAlternativeList [day, week, hourANDroom, eventType, lecture] =
  AlternativeRoom{ day      = ListToIS.removeSpaceAtEnd day
                 , week     = week
                 , state    = hour
                 , location = ListToIS.locationStringToLocation place
                 , lecture  = lecture
                 , aType    = eventType
                 }
   where
    (hour, place) = splitHourAndRoom $ filter (/= "") $ splitOn "\160" hourANDroom
--
splitAlternativeList [dayANDweekANDhourANDroom, eventType, lecture] =
  AlternativeRoom{ day      = ListToIS.removeSpaceAtEnd day 
                 , week     = week
                 , state    = hour
                 , location = ListToIS.locationStringToLocation place
                 , lecture = lecture
                 , aType    = eventType
                 }   
   where
    
    (day, week, hour, place) = splitDayAndWeekAndHoureAndRoom $ filter (/= "") $ splitOn "\160" dayANDweekANDhourANDroom
--
--
splitDayAndWeekAndHoureAndRoom [day, week, hour, room] = (day,week,hour,room)
--
--
splitHourAndRoom :: [String] -> (String, String)
splitHourAndRoom [hour, place] = ((hour, place))
--
-- 
-- =====================================================================
--
-- readAlternativeRoom :: String -> [AlternativeRoom]
readAlternativeRoom htmlDaten = findFont $ parseTags htmlDaten
--
--
findFont [] = []
findFont (tag : tags) =
  case tag of
   TagOpen "FONT" [("FACE","Courier New"),("SIZE","2")] -> skipBR tags 3
   _                      -> findFont tags
--
skipBR atag 0 = readNextBR atag
skipBR atag@(tag : tags) counter =
  case tag of
   TagOpen "BR" _ -> skipBR atag (counter-1)
   _ -> skipBR tags counter
--
--
readNextBR (tag : tags) =
  case tag of
   TagOpen "BR" _ -> (readAlternativeRooms tags) : (readNextBR tags)
   TagClose "FONT" -> []
   _ -> readNextBR tags
--
--
readAlternativeRooms atag@(tag : tags) =
  case tag of
   TagOpen "BR" _ -> []
   TagText daten  -> daten : (readAlternativeRooms tags)
   TagOpen "img" [_,("src","bilder/buch.gif"),_,_] -> "Vorlesung" : (readAlternativeRooms tags)
   TagOpen "img" [_,("src","bilder/monitor.gif"),_,_] -> "Uebung" : (readAlternativeRooms tags)
   _ -> readAlternativeRooms tags
--
--
--
