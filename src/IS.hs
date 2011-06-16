module IS where
-- tag, zeitSlot, type, name, gebaeude, raum, woche, gruppe, dozent
-- tag      = Montag, Dienstag, Mittwoch, Donnerstag, Freitag
-- zeitSlot = 08.15-09.45, 10.00-11.30, 11.45-13.15, 14.15-15.45, 16.00-17.30, 17.45-19.15
--  
-- vtype     = uebung(u), vorlesung(v)
-- name     = ist der Name der Veranstaltung
-- woch     = (g)erade, (u)ngerade, (w)oechentlich
-- gruppe   = (1..)
-- dozent   = ist der Name des Dozenten
-- =======================================================================================
-- type StundenPlan = [ 
--                   ]
--
-- stunde, minute
-- timeStamp
--
-- * Data types
-- 
-- | Der Datentype Day Beschreibt die Tage die in einer Woche vorkommen. 
--
-- The datatype Day discribes the days of a week. 
--
data Day       = Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag
                 deriving (Show, Read)
--                 deriving Read
--
-- | Der Datentype TimeStamp besteht aus der Stunde und der Minute eines Tages.
--
-- The datatype TimeStamp describe the houre and minute of a day.
--
data TimeStamp = TimeStamp   { houre  :: String -- ^ Stunde eines Tages
                             , minute :: String -- ^ Minute einer Stunde
                             }
                             deriving (Show, Read)
--
-- | Der Datentype TimeSlot besteht aus einer anfangs und ende Zeit.
--
-- The datatype TimeSlot describe the start and end of a schedule.
--
data TimeSlot  = TimeSlot    { tstart  :: TimeStamp
                             , tend    :: TimeStamp
                             }
                             deriving (Show, Read)
--
-- | 
--
data VType      = Vorlesung | Uebung
                  deriving (Show, Read)
--
data Location   = Location   { building :: String
                             , room     :: String
                             }
                             deriving (Show, Read)
--
data Week       = Gerade | Ungerade | Woechentlich
                  deriving (Show, Read)
--
-- | Beschreibt die Datenstruktur des Stundenplans. 
--
--
data Lecture    = Lecture    { day      :: String   -- ^ day of a week
                             , timeSlot :: TimeSlot -- ^ start and end Time of a schedule
                             , vtype    :: String   -- ^ describe the type of a schedule (Vorlesung,Uebung)
                             , vname    :: String   -- ^ the name of the schedule
                             , location :: Location -- ^ the location of the schedule
                             , week     :: String   -- ^ describe the week of a schedule (Gerade,Ungerade,Woechentlich)
                             , group    :: String   -- ^ describe the group of a schedule [1..]
                             , lecturer :: String   -- ^ describe the dozent name that hold the schedule
                             }
                | EmptyLecture 
                             deriving (Show, Read)
--                             deriving Read
--
-- emptyLecture = Lecture {day="", timeSlot=TimeSlot{tstart=TimeStamp{houre="",minute=""},tend=TimeStamp{houre="",minute=""}},
--  31                                                      vtype="", vname="", location=Location{building="",room=""}, week="", group="", lecturer=""}

--
--
type TimeTable  = [Lecture]
--
