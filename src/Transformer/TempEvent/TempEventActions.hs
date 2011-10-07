module Transformer.TempEvent.TempEventActions where 
-- 
--
import Transformer.TempEvent.TempEvent
import qualified Transformer.AlternativeRoom.AlternativeRoom as AR
import qualified Transformer.IS as IS
import qualified Transformer.IsToEvent as IsToEvent
import qualified Transformer.Event.EventS as Event
--
--
import qualified Data.Map as M
--
--generateTempEvents :: IS.TimeTable -> [AR.AlternativeRoom] -> String -> [TempEvent]
-- generateTempEvents (timeTable : timeTables) alternativeRooms className = [generateTempEvent timeTable alternativeRooms className]
generateTempEvents fhsIDMap timeTables alternativeRooms className = map (generateTempEvent fhsIDMap alternativeRooms className) timeTables
--
--
--generateTempEvent :: [AR.AlternativeRoom] -> String -> IS.Lecture -> TempEvent
generateTempEvent fhsIDMap alternativeRooms className timeTable = 
 TempEvent{ appointment=Appointment{ time=show $ IS.timeSlot timeTable
                                    , location=Location{ place=Place{ building=IS.building $ IS.location timeTable
                                                                    , room=IS.room $ IS.location timeTable
                                                                    }
--                                                       , alternative=map (getAlternativeRooms timeTable) alternativeRooms
                                                       , alternative=getAlternativeRooms timeTable alternativeRooms
                                                       }
                                    , day=IS.day timeTable
                                    , week=IS.week timeTable
                                    }
           , className=className
           , eventType=IS.vtype timeTable
           , member=[Member{fhs_id="",name=(IS.lecturer timeTable)}]
---           , member=matchLecturer (IS.lecturer timeTable) fhsIDMap
--           , member=[Member{ fhs_id=Event.fhs_id $ head $ IsToEvent.matchLecturer (IS.lecturer timeTable) fhsIDMap
--                           , name=IS.lecturer timeTable
--                           }]
           , titleLong=IsToEvent.readTitleLong $ IS.vname timeTable
           , titleShort=IS.vname timeTable
           , group=IS.group timeTable
           }
 
{-
getAllMembers members = Member{ fhs_id=Event.fhs_id $ head members
                              , 
-}
--
getAlternativeRooms _ [] = []
getAlternativeRooms timeTable (alternativeRoom : alternativeRooms) = 
--getAlternativeRooms timeTable alternativeRoom =
  if ( ((AR.day alternativeRoom)      == (IS.day timeTable))
--    && (AR.location alternativeRoom) == (IS.location timeTable)
    && ((AR.week alternativeRoom) == (IS.week timeTable))
    && mapHourOfTime (AR.state alternativeRoom) == show (IS.timeSlot timeTable)
    && (AR.lecture alternativeRoom) == (IS.vname timeTable)
     )
   then 
    (Alternative{ alterDay        = AR.day alternativeRoom
                , alterWeek       = AR.week alternativeRoom
                , hour            = read (AR.state alternativeRoom) :: Integer
                , alterLocation   = Place{ building = IS.building $ AR.location alternativeRoom
                                         , room     = IS.room $ AR.location alternativeRoom
                                         }
                , alterTitleShort = AR.lecture alternativeRoom
                , altereventType  = AR.aType alternativeRoom
                }) : (getAlternativeRooms timeTable alternativeRooms)
   else
    getAlternativeRooms timeTable alternativeRooms
--
--
mapHourOfTime "1" = "08.15-09.45"
mapHourOfTime "2" = "10.00-11.30"
mapHourOfTime "3" = "11.45-13.15"
mapHourOfTime "4" = "14.15-15.45"
mapHourOfTime "5" = "16.00-17.30"
mapHourOfTime "6" = "17.45-19.15"
mapHourOfTime "7" = "19.30-21.00"
mapHourOfTime "8" = "21.15-22.45"
--
--
matchLecturer lecturer fhsMap =
       case M.lookup lecturer fhsMap of
--         Just lecturerList -> 
         Just lecturerList -> map ((flip generateMember) ( M.fromList $ map reverseLecturerTupel $ M.toList fhsMap)) lecturerList
--         Just lecturerList -> [(flip generateMember) ( M.fromList $ map reverseLecturerTupel $ M.toList fhsMap) lecturerList]
         _                 -> error $ "Error lecturer: " ++ lecturer ++ " does not exist"
--
--
--generateMember :: [String] -> [Member]
--generateMember [] _ = []
generateMember fhsID lecturerMap =
--       (fhs_id=fhsID) : (generateMember fhsIDs)
--       (FhsID {fhs_id=fhsID}) : (generateMember fhsIDs)

   Member{ fhs_id = fhsID
         , name   = checkLecturer $ M.lookup [fhsID] lecturerMap
         }

--   []
-- 
checkLecturer lecturer = 
  case lecturer of
   Just lecturer' -> lecturer'
   _ -> []
--
-- | This function twist the arguments of the tuple.
reverseLecturerTupel ( nLecturer, fhsLecturer ) = ( fhsLecturer, nLecturer )
--
--
--

