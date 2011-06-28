module TestEvents where
--
import EventS
--
testLectur :: Event
testLectur = Event { titleShort="GrInfv"
                   , titleLong="Grundlagen Informationsverarbeitung"
                   , expireDate="2011-06-24 12:00:00"
                   , eventType="Lecture"
                   , degreeClass= [DegreeClass {class_id=2}]
                   , member=Member [ FhsID {fhs_id= "braun"}
--                   , member=Member [ FhsID "braun"
--                                   , fhs_id="hoeller"
--                                   , fhs_id="knolle"
                                   ]
                   , appointment=[ Appointment
                                    { startAppointment="2009-06-24 12:00:00"
                                    , endAppointment="2009-06-24 12:45:00"
                                    , status="ok"
                                    , location=[Location
                                           { building="F"
                                           , room="111"
                                           }]
                                    }      
                                 , Appointment
                                    { startAppointment="2009-06-24 13:00:00"
                                    , endAppointment="2009-06-24 12:30:00"
                                    , status="ok"
                                    , location=[Location
                                           { building="F"
                                           , room="111"
                                           }]
                                    }      
                                 ]         
                   }
{-
testLecturs :: [Event]
testLecturs=[Event { titleShort="GrInfv"
                   , titleLong="Grundlagen Informationsverarbeitung"
                   , expireDate="2011-06-24 12:00:00"
                   , eventType="Lecture"
                   , degreeClass= [DegreeClass {class_id=2}]
                   , member=Member [ {fhs_id="braun"}
                                   , {fhs_id="hoeller"}
                                   , {fhs_id="knolle"}
                                   ]   
                   , appointment=[ Appointment 
                                    { startAppointment="2009-06-24 12:00:00"
                                    , endAppointment="2009-06-24 12:45:00"
                                    , status="ok"
                                    , location=[Location 
                                           { building="F"
                                           , room="111"
                                           }]  
                                    }   
                                 , Appointment
                                    { startAppointment="2009-06-24 13:00:00"
                                    , endAppointment="2009-06-24 12:30:00"
                                    , status="ok"
                                    , location=[Location
                                           { building="F"
                                           , room="111"
                                           }]  
                                    }   
                                 ]   
                   }
            ,Event { titleShort="GrInfv"
                   , titleLong="Grundlagen Informationsverarbeitung"
                   , expireDate="2011-06-24 12:00:00"
                   , eventType="Lecture"
                   , degreeClass= [DegreeClass {class_id=2}]
                   , member=Member [ {fhs_id="braun"}
                                   , {fhs_id="hoeller"}
                                   , {fhs_id="knolle"}
                                   ]
                   , appointment=[ Appointment
                                    { startAppointment="2009-06-24 12:00:00"
                                    , endAppointment="2009-06-24 12:45:00"
                                    , status="ok"
                                    , location=[Location
                                           { building="F"
                                           , room="111"
                                           }]
                                    }
                                 , Appointment
                                    { startAppointment="2009-06-24 13:00:00"
                                    , endAppointment="2009-06-24 12:30:00"
                                    , status="ok"
                                    , location=[Location
                                           { building="F"
                                           , room="111"
                                           }]
                                    }
                                 ]
                   }
            ]
-}
