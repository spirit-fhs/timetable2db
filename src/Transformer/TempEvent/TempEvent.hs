{-
 This module is for transforming the internal structure in the Temporary event structure
-}
module Transformer.TempEvent.TempEvent where
--
--
data Place       = Place       { building       :: String
                               , room           :: String
                               }   
                               deriving (Show, Read)
--
data Alternative = Alternative { alterDay       :: String
                               , alterWeek      :: String
                               , hour           :: Integer
                               , alterLocation  :: Place
                               , alterTitleShort:: String
                               , altereventType :: String
                               }
                               deriving (Show, Read)
--
data Location    = Location    { place          :: Place
                               , alternative    :: [Alternative]
                               }
                               deriving (Show, Read)
--
data Member      = Member      { fhs_id         :: String
                               , name           :: String
                               }
                               deriving (Show, Read)
--
data Appointment = Appointment { time           :: String
                               , location       :: Location
                               , day            :: String
                               , week           :: String
                               }
                               deriving (Show, Read)
--
data TempEvent   = TempEvent   { appointment    :: Appointment
                               , className      :: String
                               , eventType      :: String
                               , member         :: [Member]
                               , titleLong      :: String
                               , titleShort     :: String
                               }
                               deriving (Show, Read)
--
--
--
--
