module Transformer.Event.EventS where
{-
{
  "titleShort":"GrInfv",
  "titleLong":"Grundlagen Informationsverarbeitung",
  "expireDate":"2011-06-24 12:00:00",
  "eventType":"Lecture",
  "degreeClass":[{
    "class_id":2
  }],
  "member":[{
    "fhs_id":"braun"
  },{
    "fhs_id":"hoeller"
  },{
    "fhs_id":"knolle"
  }],
  "appointment":[{
    "startAppointment":"2009-06-24 12:00:00",
    "endAppointment":"2009-06-24 12:45:00",
    "status":"ok",
    "location":[{
      "building":"F",
      "room":"111"
    }]
  },{
    "startAppointment":"2009-06-24 13:00:00",
    "endAppointment":"2009-06-24 12:30:00",
    "status":"ok",
    "location":[{
      "building":"F",
      "room":"111"
    }]
  }]
}
-}
data DegreeClass = DegreeClass { class_id :: Int }
               deriving (Show, Read, Eq)

--data Member      = Member { fhs_id :: String }
--               deriving Show

--newtype FhsID = FhsID String
newtype FhsID = FhsID {fhs_id :: String}
               deriving (Show, Read, Eq) 

----type FhsID = {fhs_id :: String}

--data Member = Member [FhsID]
type Member = [FhsID]
--               deriving Show
--data TestI = {fhs_id :: String}

data Location    = Location { building :: String, room :: String }
               deriving (Show, Read, Eq)

data Appointment = 
              Appointment { startAppointment :: String
                          , endAppointment   :: String
                          , status           :: String
                          , location         :: [Location]
                          }
               deriving (Show, Read, Eq) 

data Event = Event { titleShort  :: String
                   , titleLong   :: String
                   , expireDate  :: String
                   , eventType   :: String
                   , degreeClass :: [DegreeClass]
                   , member      :: Member
                   , appointment :: [Appointment]
                   }
               deriving (Show, Read, Eq) 
--
{-
instance Eq Event where
  titleShort == titleShort = True
  titleLong  == titleLong  = True
  expireDate == expireDate = True
  eventType  == eventType  = True
-}
--
type Events = [Event]
--
--
