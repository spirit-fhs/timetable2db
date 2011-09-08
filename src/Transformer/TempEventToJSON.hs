{-# LANGUAGE OverloadedStrings #-}
module Transformer.TempEventToJSON where
-- 
import Data.Aeson
import Data.Aeson.Types ( parseMaybe )
import Data.Attoparsec.Lazy hiding ( take, takeWhile )
import Control.Applicative ( (<$>), (<*>), pure )
import Data.ByteString.Lazy (ByteString, putStrLn, writeFile)
--
import Transformer.TempEvent.TempEvent
import qualified Transformer.IS as IS
--
instance ToJSON Alternative where
  toJSON ( Alternative alterDay alterWeek hour alterLocation alterTitleShort altereventType ) = 
   object [ "alterDay"        .= alterDay
          , "alterWeek"       .= alterWeek
          , "hour"            .= hour
          , "alterLocation"   .= alterLocation
          , "alterTitleShort" .= alterTitleShort
          , "altereventType"  .= altereventType
          ]
{-
instance ToJSON NoAlternative where
  toJSON ( NoAlternative ) = 
   object []
-}
--
instance ToJSON Place where
  toJSON ( Place building room ) = 
   object [ "building"    .= building
          , "room"        .= room
          ]
--
instance ToJSON Location where
  toJSON ( Location place alternative ) = 
   object [ "place"       .= place
          , "alternative" .= alternative
          ]
--
instance ToJSON Member where
  toJSON ( Member fhs_id name ) = 
   object [ "fhs_id"      .= fhs_id
          , "name"        .= name
          ]
--
instance ToJSON Appointment where
  toJSON ( Appointment time location day week ) = 
   object [ "time"        .= time
          , "location"    .= location
          , "day"         .= day
          , "week"        .= week
          ]
--
instance ToJSON TempEvent where
  toJSON ( TempEvent appointment className eventType member titleLong titleShort ) = 
   object [ "appointment" .= appointment
          , "className"   .= className
          , "eventType"   .= eventType
          , "member"      .= member
          , "titleLong"   .= titleLong
          , "titleShort"  .= titleShort
          ]
--
--
--convertIsToTempEvent :: TimeTable -> 
--
--
testTransform = Data.ByteString.Lazy.writeFile "TempEvent.json" $ encode $ tempEvent
  where 
   tempEvent =    
    TempEvent { appointment = Appointment { time="08.15-09.45"
                                          , location=Location{ place=Place{building="B", room="101"}
                                                             , alternative=[Alternative{ alterDay="Dienstag"
                                                                                       , alterWeek="Gerade"
                                                                                       , hour=5
                                                                                       , alterLocation=Place{building="B",room="PC1"}
                                                                                       , alterTitleShort="SWE V3"
                                                                                       , altereventType="Vorlesung"
                                                                                       }]
                                                             }   
                                          , day="Dienstag"
                                          , week="Gerade"
                                          }   
              , className="Bai6"
              , eventType="Vorlesung"
              , member=[Member{ fhs_id="braun"
                              , name="Braun"
                              }]  
              , titleLong="Software...."
              , titleShort="SWE V3"
              }   

--
