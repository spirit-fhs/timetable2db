module Transformer.ListToIS where
--
import Transformer.IS
import Data.Char
import Data.List.Split
--
-- | Converts the temporary structure in the TimeTable data type.
convertListToIS :: [(String, [(String, [[String]])])] -> TimeTable
--convertListToIS = rekLine
convertListToIS = concatMap slotsSpliter
--
-- | Make a line about the temporary structure in the TimeTable data type.
slotsSpliter :: (String, [(String, [[String]])]) -> TimeTable
slotsSpliter ( _ , []) = []
slotsSpliter ( time, (slot : slots) ) = (daySlot time slot) ++ (slotsSpliter (time, slots))
--
-- | Take the time and the day and filter the slots behind them.
daySlot :: String -> (String, [[String]]) -> TimeTable
daySlot _ ( _, [] ) = []
daySlot time ( slotDay, (slot : slots) ) = ((analyseSlot time slotDay slot) : ( daySlot time ( slotDay, slots )) )
-- daySlot time ( slotDay, slots) = map (analyseSlot time slotDay) slots
--
-- ==============================================================================================================
--
-- [" ","Uebung","DBS\160V1","WKST\160","g","\160\&1","Knolle "]
--
-- | This function is for matching with the slot structure.
analyseSlot :: String -> String -> [String] -> Lecture
-- ^ When in the time slot no lecture are given
analyseSlot _ _ [] = EmptyLecture
-- | This alternative is when a lecture have a alternative room.
analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocation, "*", "\160", iweek, igroup, ilecturer ] = 
     Lecture { day      = dayOfLecture
             , timeSlot = timeStringToTimeSlot timeOfLecture
             , vtype    = ivtype
             , vname    = ivname
             , location = locationStringToLocation $ removeSpaceAtEnd ilocation 
             , week     = iweek
             , group    = igroup
             , alternat = True
             , lecturer = removeSpaceAtEnd ilecturer
             }   
--
analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocation, "*", iweek, ilecturer ] =
     Lecture { day      = dayOfLecture
             , timeSlot = timeStringToTimeSlot timeOfLecture
             , vtype    = ivtype
             , vname    = ivname
             , location = locationStringToLocation $ removeSpaceAtEnd ilocation
             , week     = filter (/= '\160') iweek
             , group    = ""
             , alternat = True
             , lecturer = removeSpaceAtEnd ilecturer
             }
--
--
analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocation, iweek, igroup, ilecturer ] =
     Lecture { day      = dayOfLecture
             , timeSlot = timeStringToTimeSlot timeOfLecture
             , vtype    = ivtype
             , vname    = ivname
             , location = locationStringToLocation $ removeSpaceAtEnd ilocation 
             , week     = iweek
             , group    = igroup
             , alternat = False
             , lecturer = removeSpaceAtEnd ilecturer
             }
{-
-- | The exception when the location and the week are in the same string
--  example: [" ","Vorlesung","SWEProg\160V2","H0216\160w\160","Recknagel "]
-- analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocation, iweek, ilecturer ] =
-- analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocationUiweek, ilecturer ] =
analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocationUiweek, ilecturer ] =
    Lecture { day      = dayOfLecture
            , timeSlot = timeStringToTimeSlot timeOfLecture
            , vtype    = ivtype
            , vname    = ivname
            , location = locationStringToLocation $ removeSpaceAtEnd olocation 
            , week     = [oweek]
            , group    = ""
            , alternat = False
            , lecturer = removeSpaceAtEnd ilecturer
            }
  where 
   (olocation, oweek) = splitLocationANDWeek ilocationUiweek
-}
--
analyseSlot timeOfLecture dayOfLecture [ " ", ivtype, ivname, ilocationUiweekOigroup, ilecturer ] =
    Lecture { day      = dayOfLecture
            , timeSlot = timeStringToTimeSlot timeOfLecture
            , vtype    = ivtype
            , vname    = ivname
            , location = locationStringToLocation $ removeSpaceAtEnd olocation
            , week     = oweek
            , group    = ogroup
            , alternat = False
            , lecturer = removeSpaceAtEnd ilecturer
            }
  where
   (olocation, oweek, ogroup) = splitLocationANDWeekAndGroup $ splitOn "\160" ilocationUiweekOigroup
--
--
-- This alternative is for block events
analyseSlot timeOfLecture dayOfLecture [ ivtype, ivname, ilocation, ilecturer ] = 
    Lecture { day      = dayOfLecture
            , timeSlot = timeStringToTimeSlot timeOfLecture
            , vtype    = ivtype
            , vname    = ivname
            , location = locationStringToLocation $ removeSpaceAtEnd ilocation 
            , week     = ""
            , group    = ""
            , alternat = False
            , lecturer = removeSpaceAtEnd ilecturer
            }   
--
--
--
-- ==============================================================================================================
--
-- | This function removes the space at the end of a string.
removeSpaceAtEnd :: String -> String
removeSpaceAtEnd [] = []
removeSpaceAtEnd ( ' ' : [] ) = []
removeSpaceAtEnd ( '\160' : [] ) = []
removeSpaceAtEnd ( xString : xssString ) = xString : (removeSpaceAtEnd xssString)
--
-- | This function splits the Location and week at one string by a space.
splitLocationANDWeek :: String -> (String, Char)
splitLocationANDWeek (' ' : x : xss) = ( [], x)
splitLocationANDWeek ('\160' : x : xss) = ( [], x)
splitLocationANDWeek (x : xss)       = ( x : (fst (splitLocationANDWeek xss)), (snd (splitLocationANDWeek xss)))
--
--
splitLocationANDWeekAndGroup :: [String] -> (String, String, String)
-- splitLocationANDWeekAndGroup (' ' : x1 : ' ' : x2 : xss)       = ([], x1, x2)
splitLocationANDWeekAndGroup [ room, week, group ] = (room, week, group)
splitLocationANDWeekAndGroup [ room, week ]        = (room, week, [])
--
--splitLocationANDWeekAndGroup ('\160' : x1 : '\160' : ' ' : xss) = ([], x1, )
--splitLocationANDWeekAndGroup ('\160' : x1 : '\160' : x2 : xss) = ([], x1, x2)
--splitLocationANDWeekAndGroup ('\160' : x1 : '\160' : xss) = ([], x1, ' ')
--splitLocationANDWeekAndGroup (x : xss)                         = ( (x : e1) , e2, e2)
--  where
--   (e1, e2, e3) = splitLocationANDWeekAndGroup xss
--
-- | Transform a time string to a TimeSlot data type.
timeStringToTimeSlot :: String -> TimeSlot
timeStringToTimeSlot ( h11 : h12 : _ : m11 : m12 : _ : h21 : h22 : _ : m21 : m22 : rst ) =
     TimeSlot { tstart = TimeStamp { hour = [h11,h12] , minute = [m11,m12] }
              , tend   = TimeStamp { hour = [h21,h22] , minute = [m21,m22] }
              } 
timeStringToTimeSlot ( h12 : _ : m11 : m12 : _ : h21 : h22 : _ : m21 : m22 : rst ) = 
     TimeSlot { tstart = TimeStamp { hour = [h12] , minute = [m11,m12] }
              , tend   = TimeStamp { hour = [h21,h22] , minute = [m21,m22] }
              }
--
--
-- 
-- | This function is needed to transfor the location string into
--   a Location data.
--   For rooms with names and no building and number there is a matcher.
--   For a combination about building and number there is a split function.
--   For example the building is 'H' and the room number is '0202' then the string
--   is H0202.
locationStringToLocation :: String -> Location
locationStringToLocation []     = Location{building="", room=""}
locationStringToLocation "WKST" = Location{building="B", room="WKST"}
locationStringToLocation "PC1"  = Location{building="B", room="PC1"}
locationStringToLocation "PC2"  = Location{building="F", room="PC2"}
locationStringToLocation "PC3"  = Location{building="F", room="PC3"}
--
locationStringToLocation "PC2_"  = Location{building="F", room="PC2"}
locationStringToLocation "WKST_"  = Location{building="B", room="WKST"}
--
-- TODO: es muss ein ordentlicher Parser gebaut werden.
locationStringToLocation (room : number) = Location{building=[room], room=(removeSpaceAtEnd number)}
--
--
--
--
printTimeTable :: TimeTable -> IO ()
printTimeTable [] = return ()
printTimeTable (lecture : timeTable) = do
     print lecture
--     print "---------"
     printTimeTable timeTable
--
--
