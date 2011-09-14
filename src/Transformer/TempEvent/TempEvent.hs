{-
 This module is for transforming the internal structure in the Temporary event structure
-}
module Transformer.TempEvent.TempEvent where
--
--
data Place       = Place       { building       :: String
                               , room           :: String
                               }   
                               deriving (Read)
instance Eq Place where
  a == b = (building a) == (building b)
        && (room a) == (room b)
instance Show Place where
  show = placeToString
--
placeToString a =
  building a ++ " " ++ room a
--
--
data Alternative = Alternative { alterDay       :: String
                               , alterWeek      :: String
                               , hour           :: Integer
                               , alterLocation  :: Place
                               , alterTitleShort:: String
                               , altereventType :: String
                               }
                               deriving (Read)
instance Show Alternative where
  show = alternativToString
--
alternativToString a =
  alterDay a ++ " " ++ alterWeek a ++ " " ++ show (hour a) ++ " " ++ show (alterLocation a) ++ " " ++ alterTitleShort a ++ " " ++ altereventType a
--
--
data Location    = Location    { place          :: Place
                               , alternative    :: [Alternative]
                               }
                               deriving (Read)
instance Show Location where
  show = locationToString
--
locationToString :: Location -> String
locationToString a =
  show (place a) ++ " " ++ show (alternative a) 
--
--
data Member      = Member      { fhs_id         :: String
                               , name           :: String
                               }
                               deriving (Read)
instance Show Member where
  show = memberToString
--
memberToString a = 
  fhs_id a ++ " " ++ name a
--
--
data Appointment = Appointment { time           :: String
                               , location       :: Location
                               , day            :: String
                               , week           :: String
                               }
                               deriving (Read)
instance Show Appointment where
  show = appointmentToString
--
appointmentToString :: Appointment -> String
appointmentToString a =
  time a ++ " " ++ show (location a) ++ " " ++ day a ++ " " ++ week a
--
--
data TempEvent   = TempEvent   { appointment    :: Appointment
                               , className      :: String
                               , eventType      :: String
                               , member         :: [Member]
                               , titleLong      :: String
                               , titleShort     :: String
                               , group          :: String
                               }
                               deriving (Read)
instance Show TempEvent where
--  show = show appointment ++ className ++ eventType ++ show member ++ titleLong ++ titleShort ++ group 
  show = tempEventToString
--  show = appointment a ++ className a ++ eventType a ++ member a ++ titleLong a ++ titleShort a ++ group a
--  show = appointment ++ className ++ eventType ++ member ++ titleLong ++ titleShort ++ group 
--
tempEventToString :: TempEvent -> String
tempEventToString a =
    show (appointment a) ++ " " 
 ++ (className a)        ++ " "
 ++ (eventType a)        ++ " " 
 ++ show (member a)      ++ " " 
 ++ (titleLong a)        ++ " " 
 ++ (titleShort a)       ++ " "
 ++ (group a)            ++ "\n"
--
--
--
