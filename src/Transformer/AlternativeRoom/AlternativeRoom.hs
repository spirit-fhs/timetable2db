module Transformer.AlternativeRoom.AlternativeRoom where
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
                  , location   :: Place
                  , lecturer   :: String
                  , aType      :: String
                  }
                  deriving (Show, Read)
--
--
readAlternativeRoom :: String -> [AlternativeRoom]
readAlternativeRoom htmlDaten = []
--
--
--
