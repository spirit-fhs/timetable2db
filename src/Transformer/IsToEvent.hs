module Transformer.IsToEvent where
--
--
import qualified Transformer.IS as IS
import Transformer.Event.EventS
--
import qualified Data.Map as M
--
--import Data.Aeson
--import Data.Aeson.Types ( parseMaybe )
---import Data.Attoparsec.Lazy hiding ( take, takeWhile )
--import Control.Applicative ( (<$>), (<*>), pure )
--import Data.ByteString.Lazy (ByteString, putStrLn, writeFile)
--
--import TimeTableToJSONv2
--
--
-- TODO: es muss die class_id noch abgefragt werden, damit die daten richtig eingefuegt werden koennen
--
--
--convertISToEventS :: IS.TimeTable -> Int -> [String] -> (String,String) -> String -> Events
convertISToEventS [] _ _ _ _ = []
convertISToEventS (lecture : timeTable) classID fhsIDMap eventStamp expire = 
      (Event { titleShort  = IS.vname lecture
             , titleLong   = readTitleLong $ IS.vname lecture
             , expireDate  = expire
             , eventType   = transformVType $ IS.vtype lecture
             , degreeClass = [DegreeClass {class_id=classID}]
--             , member      = Member $ generateMember fhsIDs
--             , member      = generateMember fhsIDs
             , member      = matchLecturer (IS.lecturer lecture) fhsIDMap 
             , appointment = generateAppointment eventStamp (IS.location lecture) (IS.week lecture)
             }
      ) : (convertISToEventS timeTable classID fhsIDMap eventStamp expire)
--
--
convertISToEventS' [] _ _ _ _ = []
convertISToEventS' (lecture : timeTable) classID fhsIDMap eventStamp expire =
      (Event { titleShort  = IS.vname lecture
             , titleLong   = readTitleLong $ IS.vname lecture
             , expireDate  = expire
             , eventType   = transformVType $ IS.vtype lecture
             , degreeClass = [DegreeClass {class_id=classID}]
             , member      = matchLecturer (IS.lecturer lecture) fhsIDMap
             , appointment = generateAppointment' ( (IS.day lecture)
                                                  , IS.timeSlotToString (IS.timeSlot lecture)
                                                  ) 
                                                  (IS.location lecture) 
                                                  (IS.week lecture)
             }
       ) : (convertISToEventS' timeTable classID fhsIDMap eventStamp expire)
--
--

--
--
generateAppointment' :: (String,String) -> IS.Location -> String -> [Appointment]
--generateAppointment' (startEvent,endEvent) location week = []
--
generateAppointment' (startEvent,endEvent) location week = 
         [Appointment { startAppointment=startEvent
                      , endAppointment=endEvent
                      , status=week
                      , location=[Location { building=(IS.building location)
                                           , room=(IS.room location)
                                           }
                                 ] 
                      }
         ]
--
--
transformVType :: String -> String
transformVType "Vorlesung" = "Lecture"
transformVType "Uebung"    = ""
transformVType ""          = "Nothing"
--
--
-- ein generator um alle appointments zu generieren
generateAppointment :: (String,String) -> IS.Location -> String -> [Appointment]
generateAppointment (startEvent,endEvent) location week = []
--
--
--matchLecturer :: String -> M.Map -> [String]
matchLecturer lecturer fhsMap = 
       case M.lookup lecturer fhsMap of
         Just lecturerList -> generateMember lecturerList 
--         _                 -> error "Lecturer: " ++ lecturer ++ " not found in Map"
         _                 -> []
--
--
--generateMember :: [String] -> [Member]
generateMember [] = []
generateMember (fhsID : fhsIDs) = 
--       (fhs_id=fhsID) : (generateMember fhsIDs)
       (FhsID {fhs_id=fhsID}) : (generateMember fhsIDs)
--       (memb) : (generateMember fhsIDs)
--
--    where 
--     memb = case (Member {fhs_id=fhsID}) of 
--              Member x -> x
--
-- | This function is for the name resolution.
-- The first parameter is the short name and the output is the long name
-- of a lecture.
readTitleLong :: String -> String
readTitleLong "GrInfv" = "Grundlagen Informationsverarbeitung"
readTitleLong titleShort = []
--
--
--
