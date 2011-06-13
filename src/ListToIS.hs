module ListToIS where
--
import IS
import Data.Char
--
convertListToIS :: [(String, [(String, [[String]])])] -> TimeTable
-- convertListToIS rowList = rekLine rowList
convertListToIS = rekLine
--
--
rekLine :: [(String, [(String, [[String]])])] -> TimeTable
-- rekLine [] = []
-- rekLine ( line : lines ) = (slots line) ++ (rekLine lines)
rekLine = concatMap slots
--
--
slots :: (String, [(String, [[String]])]) -> TimeTable
-- slots ( _ , []) = []
slots ( time, (slot : slots) ) = (daySlot time slot) 
--
--
daySlot :: String -> (String, [[String]]) -> TimeTable
-- daySlot _ ( _, [] ) = []
-- daySlot time ( slotDay, (slot : slots) ) = ((analyseSlot time slotDay slot) : ( daySlot time ( slotDay, slots )) )
daySlot time ( slotDay, slots) = map (analyseSlot time slotDay) slots
--
--
analyseSlot :: String -> String -> [String] -> Lecture
-- ^ When in the time slot no lecture are given
analyseSlot timeOfLecture dayOfLecture [] = Lecture {day="", timeSlot=TimeSlot{tstart=TimeStamp{houre="",minute=""},tend=TimeStamp{houre="",minute=""}},
                                                     vtype="", vname="", location=Location{building="",room=""}, week="", group="", lecturer=""}
analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocation, iweek, igroup, ilecturer ] =
     Lecture { day      = dayOfLecture
             , timeSlot = timeStringToTimeSlot timeOfLecture
             , vtype    = ivtype
             , vname    = ivname
             , location = locationStringToLocation ilocation 
             , week     = iweek
             , group    = igroup
--             , group    = 0
             , lecturer = ilecturer
             }
-- 
-- | The exception when the location and the week are in the same string
--  example: [" ","Vorlesung","SWEProg\160V2","H0216\160w\160","Recknagel "]
-- analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocation, iweek, ilecturer ] =
-- analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocationUiweek, ilecturer ] =
analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocationUiweek, ilecturer ] =
    Lecture { day      = dayOfLecture
            , timeSlot = timeStringToTimeSlot timeOfLecture
            , vtype    = ivtype
            , vname    = ivname
            , location = locationStringToLocation $ fst $ splitLocationANDWeek ilocationUiweek 
            , week     = [snd $ splitLocationANDWeek ilocationUiweek]
            , group    = ""
            , lecturer = ilecturer
            }

{-
analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocation, iweek, igroup, ilecturer ] =
     Lecture { day      = dayOfLecture
             , timeSlot = timeStringToTimeSlot timeOfLecture
             , vtype    = ivtype
             , vname    = ivname
             , location = locationStringToLocation ilocation
             , week     = iweek
--             , group    = igroup
             , group    = 0
             , lecturer = ilecturer
             }
-}
--analyseSlot time day lecture = Lecture {day="", timeSlot=TimeSlot{tstart=TimeStamp{houre="",minute=""},tend=TimeStamp{houre="",minute=""}},
--                                        vtype="", vname="", location=Location{building="",room=""}, week="", group=0, lecturer=""}
--
splitLocationANDWeek :: String -> (String, Char)
splitLocationANDWeek ('\160' : x : xss) = ( [], x)
splitLocationANDWeek (x : xss)       = ( x : (fst (splitLocationANDWeek xss)), (snd (splitLocationANDWeek xss)))
--
--
timeStringToTimeSlot :: String -> TimeSlot
timeStringToTimeSlot ( h11 : h12 : _ : m11 : m12 : _ : h21 : h22 : _ : m21 : m22 : rst ) =
     TimeSlot { tstart = TimeStamp { houre = [h11,h12] , minute = [m11,m12] }
              , tend   = TimeStamp { houre = [h21,h22] , minute = [m21,m22] }
              } 
--
--
locationStringToLocation :: String -> Location
locationStringToLocation "WKST\160" = Location{building="B", room="WKST"}
locationStringToLocation "PC2\160"  = Location{building="F", room="PC2"}
--locationStringToLocation "D117\160"  = Location{building="D", room="117"}
locationStringToLocation "PC3\160"  = Location{building="F", room="PC3"}
--locationStringToLocation "B231\160"  = Location{building="B", room="231"}
-- TODO: es muss ein ordentlicher Parser gebaut werden.
locationStringToLocation (room : number) = Location{building=[room], room=number}
--
--
--
--
--
--
