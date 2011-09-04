module HtmlToListV2 ( tableList'
                    , testFile
                    ) where
--
import Text.HTML.TagSoup
import Text.HTML.TagSoup.Tree
import Data.Char
--
-- Tabellen gesteuerter Interpreter für Kellerautomaten.
--
palTab :: [( (String  , Integer), (Integer, String))]
palTab = [ ( ("TR"    , 0 ), (1, "") )

         , ( ("TH"    , 1 ), (2, "") )
         , ( ("TD"    , 1 ), (3, "") )
         , ( ("/TR"   , 1 ), (0, "") )

         , ( ("TEXT!" , 2 ), (2, "PUSH") ) -- "TEXT!" ist selber definiert!
         , ( ("/TH"   , 2 ), (1, "") )

         , ( ("TEXT!" , 3 ), (3, "PUSH") ) -- "TEXT!" ist selber definiert!
         , ( ("TABLE" , 3 ), (4, "") )
         , ( ("/TD"   , 3 ), (1, "") )

         , ( ("/TABLE", 4 ), (3, "") )
         , ( ("TR"    , 4 ), (5, "") )

         , ( ("TD"    , 5 ), (6, "") )
         , ( ("/TR"   , 5 ), (4, "") )
 
         , ( ("TEXT!" , 6 ), (6, "PUSH") )
         , ( ("IMAG!" , 6 ), (6, "PUSH") )
         , ( ("/TD"   , 6 ), (5, "") )
         ]
--
--
tableList' :: String -> [(String, [(String, [[String]])])]
tableList' htmlCode = arrayToListTupel $ reverse $ checkState (parseTags htmlCode) 0 palTab [] [] []
--
-- | This function transform the list from the checkState function into the temporary structure
arrayToListTupel :: [[[String]]] -> [(String, [(String, [[String]])])]
arrayToListTupel ( _ : [] ) = []
arrayToListTupel ( rowDays@(_ : rowTableHead) : (((time : _) : columns) : lines) ) =  
    ( (time, (joinDayAndTime tableHead columns))
    : (arrayToListTupel (rowDays : lines) )
    )
  where
   tableHead = concat rowTableHead
--
joinDayAndTime :: [String] -> [[String]] -> [(String, [[String]])]
joinDayAndTime [] _ = []
joinDayAndTime _ [] = []
joinDayAndTime aday@(day : days) (column@(elm1 : elemN) : columns) = 
   case elm1 of
    "\160" -> (day, []) : (joinDayAndTime days columns)
    []     -> joinDayAndTime aday columns
    _      -> (day,moreElem) : (joinDayAndTime days restElem)
     where
      (moreElem, restElem) = readMoreElem (column : columns)
--
readMoreElem :: [[String]] -> ([[String]],[[String]])
readMoreElem [] = ([], [])
readMoreElem (column : columns) = 
   case column of
    []     -> ([], columns)
    _      -> (((column) : elemN), rest)
     where
      (elemN, rest) = readMoreElem columns
--
testFile = do 
   htmlCode <- readFile "../vorlage/s_bai6_unix.html"
   print $ arrayToListTupel $ reverse $ test htmlCode
--
test htmlCode = checkState (parseTags htmlCode) 0 palTab [] [] []
--
-- | Dissolve the Tag String in a tuple with tag and datas.
--   In this function is a "bug" its transform the lower case to
--   the upper case, better is a function they make that automatically
intKA :: Tag [Char] -> (String, String)
intKA input =
  case input of
   TagOpen  "TR"    _ -> ("TR", [])
   TagOpen  "tr"    _ -> ("TR", [])
   TagOpen  "TD"    _ -> ("TD", [])
   TagOpen  "TH"    _ -> ("TH", [])
   TagOpen  "TABLE" _ -> ("TABLE", [])

   TagOpen  "img" (_ : ("src", "bilder/monitor.gif") : _)  -> ("IMAG!", "Uebung")
   TagOpen  "img" (_ : ("src", "bilder/buch.gif")    : _)  -> ("IMAG!", "Vorlesung")

   TagClose tag       -> (('/' : (map toUpper tag)), [])
   TagText      value -> ("TEXT!", value)
   _                  -> ([], [])
--
-- | This function search in the stateTable about the follow states.
--   When it find one then the function is looking for a action
checkState :: [Tag [Char]] -> Integer ->  [((String, Integer), (Integer, String))] -> [String] -> [[String]] -> [[[String]]] 
           -> [[[String]]] -- ^ Returns a reverse element structure
checkState [] _ _ _ _ stackStockFul = stackStockFul
checkState (input : inputs) state stateTable stackStock1 stackStock2 stackStockFul =
    if (folgZ == []) 
     then
      -- no follow state located
       checkState inputs state stateTable  stackStock1 stackStock2 stackStockFul
     else
      -- follow state located
      case tag of 
       "/TD"  -> closeTDTH
       "/TH"  -> closeTDTH
-- -----------------------------------------------------------------
       "/TR"  ->
        if ( state < 4 )
         -- when this is calling then a complete line is readed
         then closeTR
         -- when this is calling then the line break is to deep
         else anythingElse
-- -----------------------------------------------------------------
       -- this was call when the information finder are running
       _      -> anythingElse
    where 
     (tag, value) = intKA input
     folgZ        = findFollowState (tag, state) value stateTable
     closeTDTH    = checkState inputs (head folgZ) stateTable [] ((reverse stackStock1) : stackStock2) stackStockFul
     closeTR      = checkState inputs (head folgZ) stateTable [] [] ((reverse stackStock2) : stackStockFul)
     anythingElse = checkState inputs (head folgZ) stateTable (stackAction stackStock1 (tag, state) value stateTable) stackStock2 stackStockFul
--
--
-- | This function is searching for a follow state and do a action.
stackAction :: [String] -> (String, Integer) -> String -> [((String, Integer), (Integer, String))] -> [String]
stackAction stackStock _ _ [] = stackStock
stackAction stackStock inputFollow value ( (stateInfo, (_ ,action)) : rest) = 
   if ( inputFollow == stateInfo )
    then
     -- Aktion ausführen
     doAktion stackStock value action
    else
     -- weiter suchen
     stackAction stackStock inputFollow value rest
--
-- | This function do actions.
doAktion :: [String] ->  String -> String -> [String]
doAktion stackStock findedDatas action = 
   case action of
    -- | Save the finded datas in a list
    "PUSH"   ->  findedDatas : stackStock
    -- | Return the stack when no action available
    _ -> stackStock
--
-- | This function is for finding the next state.
findFollowState :: (String, Integer) -> String -> [((String, Integer), (Integer, String))] -> [Integer]
findFollowState _ _ [] = []
findFollowState input value ((stateInfo, (followStateVar, _)) : rest ) = 
   if ( input == stateInfo )
    then
     -- zustand gefunden
     [followStateVar]
    else
     -- zustand nicht gefunden
     findFollowState input value rest
--
--
