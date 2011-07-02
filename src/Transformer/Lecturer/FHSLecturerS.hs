module Transformer.Lecturer.FHSLecturerS where
--
--
data Oid = Oid { oid :: String }
      deriving Show
--
--
data TypeD =
       TypeD { name                  :: String 
             , requiredTime          :: Integer
             , hasLectureship        :: Bool
             }
      deriving Show
--
--
data Dozent = 
       Dozent { name'                :: String
              , reasonSelfManagement :: String
              , timeSelfManagement   :: Integer
              , typeD                :: TypeD
              }
      deriving Show
--
--
data FHSLecturerS = 
       FHSLecturerS { id             :: Oid
                    , fhsId          :: String
                    , dozent         :: Dozent
                    }
      deriving Show
--
type FHSLecturerSList = [FHSLecturerS]
--
