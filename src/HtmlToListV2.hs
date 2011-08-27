module TabellenInterpreter where
--
import Text.HTML.TagSoup
import Text.HTML.TagSoup.Tree
--
-- Tabellen gesteuerter Interpreter für Kellerautomaten.
--
-- palTab :: [(([Attribute [Char]] -> Tag [Char], Integer, [Attribute [Char]] -> Tag [Char]), (Integer, [Char]))]
--palTab :: [( ( Tag, Integer, Tag ), ( Integer, String ) )]
palTab = [ ( ("TR"    , 0 ), (1, "") )

         , ( ("TH"    , 1 ), (2, "") )
         , ( ("TD"    , 1 ), (3, "") )
         , ( ("/TR"   , 1 ), (0, "") )

         , ( ("TEXT!" , 2 ), (2, "PUSH") ) -- "TEXT!" ist selber definiert!
         , ( ("/TH"   , 2 ), (1, "") )
--         , ( ("/TR"   , 2 ), (0, "") )

         , ( ("TEXT!" , 3 ), (3, "PUSH") ) -- "TEXT!" ist selber definiert!
         , ( ("TABLE" , 3 ), (4, "") )
--         , ( ("/TABLE", 3 ), (1, "") )
         , ( ("/TD"   , 3 ), (1, "") )

         , ( ("/TABLE", 4 ), (3, "") )
         , ( ("TR"    , 4 ), (5, "") )
--         , ( ("/TR"   , 4 ), (3, "") )

         , ( ("TD"    , 5 ), (6, "") )
         , ( ("/TR"   , 5 ), (4, "") )
 
         , ( ("TEXT!" , 6 ), (6, "PUSH") )
         , ( ("IMAG!" , 6 ), (6, "PUSH") )
         , ( ("/TD"   , 6 ), (5, "") )
--         , ( ("/TR"   , 6 ), (3, "") )
         ]
--
--testFile :: IO String
testFile = do 
--   htmlCode <- readFile "testTimeTable.html"
   htmlCode <- readFile "s_bai6_unix.html"
   print $ reverse $ test htmlCode
--
printHTML = do
   htmlCode <- readFile "s_bai6_unix.html"
   print $ parseTags htmlCode
--
test htmlCode = checkState (parseTags htmlCode) 0 palTab [] [] []
--
intKA :: Tag [Char] -> (String, String)
intKA input =
  case input of
--   TagOpen  tag _     -> (tag, [])
   TagOpen  "TR"    _ -> ("TR", [])
   TagOpen  "TD"    _ -> ("TD", [])
   TagOpen  "TH"    _ -> ("TH", [])
   TagOpen  "TABLE" _ -> ("TABLE", [])

   TagOpen  "img" (_ : ("src", "bilder/monitor.gif") : _)  -> ("IMAG!", "Uebung")
   TagOpen  "img" (_ : ("src", "bilder/buch.gif")    : _)  -> ("IMAG!", "Vorlesung")

   TagClose tag       -> (('/' : tag), [])
   TagText      value -> ("TEXT!", value)
   _                  -> ([], [])
--
--
checkState :: [Tag [Char]] -> Integer ->  [((String, Integer), (Integer, String))] -> [String] -> [[String]] -> [[[String]]] -> [[[String]]]
checkState [] _ _ _ _ kellerBestandVoll = kellerBestandVoll
checkState (input : inputs) zustand zustandsTabelle kellerBestand1 kellerBestand2 kellerBestandVoll =
    if (folgZ == []) 
     then
      -- kein Folgezustand gefunden
       checkState inputs zustand zustandsTabelle kellerBestand1 kellerBestand2 kellerBestandVoll
     else
      -- Folgezustand vorhanden
      case tag of 
       "/TD"  ->
        checkState inputs
                   (head folgZ) 
                   zustandsTabelle 
                   []  
                   ((reverse kellerBestand1) : kellerBestand2)
                   kellerBestandVoll
       "/TH"  -> 
        checkState inputs
                   (head folgZ)
                   zustandsTabelle
                   []
                   ((reverse kellerBestand1) : kellerBestand2)
                   kellerBestandVoll
-- -----------------------------------------------------------------
       "/TR"  ->
        if ( zustand < 4 )
         then 
          checkState inputs
                     (head folgZ)
                     zustandsTabelle
                     []
                     []
                     ((reverse kellerBestand2) : kellerBestandVoll)
         else
          checkState inputs
                     (head folgZ)
                     zustandsTabelle
                     (kellerAktion kellerBestand1 (tag, zustand) value zustandsTabelle)
                     kellerBestand2
                     kellerBestandVoll
       _      ->
        checkState inputs
                   (head folgZ)
                   zustandsTabelle
                   (kellerAktion kellerBestand1 (tag, zustand) value zustandsTabelle)
                   kellerBestand2
                   kellerBestandVoll
    where 
     (tag, value) = intKA input
     folgZ        = folgeZustand (tag, zustand) value zustandsTabelle
--
--
--
kellerAktion :: [String] -> (String, Integer) -> String -> [((String, Integer), (Integer, String))] -> [String]
kellerAktion kellerBestand _ _ [] = kellerBestand
kellerAktion kellerBestand eingabeFolge@(hEingabe, state) value ( (zustandInfo, (folgeZustandVar,aktion)) : rest) = 
   if ( eingabeFolge == zustandInfo )
    then
     -- Aktion ausführen
     doAktion kellerBestand value aktion
    else
     -- weiter suchen
     kellerAktion kellerBestand eingabeFolge value rest
--
--
doAktion :: [String] ->  String -> String -> [String]
doAktion kellerBestand hEingabe aktion = 
   case aktion of
    "PUSH"   ->  hEingabe : kellerBestand
    _ -> kellerBestand
--
--
folgeZustand :: (String, Integer) -> String -> [((String, Integer), (Integer, String))] -> [Integer]
folgeZustand _ _ [] = []
folgeZustand eingabe value zustandsTabelle@( (zustandInfo, (folgeZustandVar, _)) : rest ) = 
   if ( eingabe == zustandInfo )
    then
     -- zustand gefunden
     [folgeZustandVar]
    else
     -- zustand nicht gefunden
     folgeZustand eingabe value rest
--
--
