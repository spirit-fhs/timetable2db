module HtmlToList where
--
--
import Text.HTML.TagSoup
--
--
data TableContent = TableContent { content :: [String] } deriving (Show)
--
testTableContent :: TableContent
testTableContent = TableContent { content = [" ","Vorlesung","DBS\160V1","WKST\160","g","\160\&1","Knolle "] }
--
--
-- data TableTD = TableTD1 { < TableContent }
--             | TableTD {  }
--
--
--
readL :: FilePath -> IO String
readL file = do
        daten <- readFile file
        return daten
--
--
--
tableHead :: [Tag [Char]] -> ([String], [Tag String])
tableHead (tag : tags) =
     case tag of
      TagOpen "TH" content -> ((((tableText' tags) : (fst (tableHead tags)))), (snd (tableHead tags)))
      TagClose "TR" -> ([], tags)
      _ -> tableHead tags
--
--
tableText' (tag : tags) =
     case tag of
      TagText text -> text
      TagClose "TD" -> []
      _ -> tableText' tags
--
-- ==============================================================================
--
--
findTime (tag : tags) =
     case tag of
      TagOpen "TD" content -> ((tableText' tags), tags)
      TagClose "TD" -> ([], tags)
      _ -> findTime tags
--
--
tableTDText (tag : tags) =
     case tag of
      TagText text -> ((text : (fst (tableTDText tags))), (snd (tableTDText tags)))
      TagOpen "img" (_ : (_,"bilder/monitor.gif") : _) -> (("Uebung" : (fst (tableTDText tags))), 
                                                                       (snd (tableTDText tags)))
      TagOpen "img" (_ : (_,"bilder/buch.gif") : _)    -> (("Vorlesung" : (fst (tableTDText tags))), 
                                                                          (snd (tableTDText tags)))
      TagClose "TD" -> ([], tags)
      _ -> tableTDText tags
--
--
readSlots :: [String] -> [Tag String] -> ([[String]], [Tag String])
readSlots days (tag : tags) =
     case tag of
      TagOpen "TD" content -> (((fst (tableTDText tags)) : (fst rek)), (snd rek))
      TagClose "TABLE" -> ([], tags)
--      TagClose "TR" -> ([], tags)
      _ -> readSlots days tags
   where 
    rek = (readSlots days (snd (tableTDText tags)))
--
--
tableTD :: [String] -> [Tag String] -> ([[String]], [Tag String])
tableTD days (tag : tags) =
     case tag of
--      TagOpen "TABLE" content -> ( ((fst rek) ++ (fst (tableTD days (snd rek))))
--                                 , (snd (tableTD days (snd rek)))
--                                 )
--      TagOpen "TABLE" content -> ((fst (readSlots days tags)), tags)
--      TagClose "TABLE" -> ([], tags)
--
      -- ^ Rekursion ist hier erforderlich, da bis zum /TD gelesen werden muss, dass nach dem /TABLE kommt.
      -- Sonst passiert es das Zeichen doppelt gelesen werden.
      TagOpen "TABLE" content -> (((fst rek) ++ (fst td)), (snd td))
--      TagOpen "TABLE" content -> ((fst rek), tags)
      TagClose "TD" -> ([], tags)
--      TagClose "TABLE" -> ([], tags)
      _ -> tableTD days tags
   where
    rek = readSlots days tags
    td  = tableTD days (snd rek)
--
--
--searchTable :: [String] -> [Tag String] -> ([[String]], [Tag String])
--searchTable days (tag : tags) =
--     case tag of
--      TagOpen  "TD" content -> tableTD 
--      
--
--
tableTR :: [String] -> [Tag String] -> ([(String, [[String]])], [Tag String])
--tableTR [] _ = ([], [])
tableTR days (tag : tags) =
     case tag of
      -- ^ Baut ein Tuppel das den Tag und die Liste von Slots beinhaltet, die an diesem Tag statt finden.
      TagOpen  "TD" content -> ((((head days), (fst td)) : (fst tr)), 
                                (snd tr))
--      TagOpen  "TD" content -> ((((head days), (fst td)) : (fst (tableTR (tail days) tags)) ), tags)
      TagClose "TR" -> ([], tags)
      TagClose "TD" -> ([], tags)
      _ -> tableTR days tags
    where
     td = tableTD days tags
     tr = tableTR (tail days) (snd td)
--
--
skipFirstTD :: [String] -> [Tag String] -> ([(String, [[String]])], [Tag String])
skipFirstTD days atags@(tag : tags) =
     case tag of
      TagClose "TD" -> tableTR days tags
      TagClose "TR" -> ([], atags)
      _ -> skipFirstTD days tags
--
--
searchTR :: [String] -> [Tag String] -> ([(String, [(String, [[String]])])], [Tag String])
-- searchTR [] _ = ([], [])
searchTR days (tag : tags) =
     case tag of
      TagOpen "TR" content -> ((( time, slot) : (fst rekursion)), ( snd rekursion ))
--      TagOpen "TR" content -> ((( "TIME", slot) : (fst rekursion)), ( snd rekursion ))
--      TagClose "TR" -> ([], tags)     -- ^ Fuer den fall, dass keine Zeile in der Tabelle ist.
      TagClose "TABLE" -> ([], tags)  -- ^ Fuer den fall, dass ein sauberes ende vollzogen werden kann.
      _ -> searchTR days tags
    where
     time     = fst $ findTime tags
     slot     = fst $ skipFirstTD days tags
     restPars = snd $ skipFirstTD days tags
     rekursion = searchTR days restPars
--
--
table :: [String] -> [Tag String] -> ([(String, [(String, [[String]])])], [Tag String])
table days atag@(tag : tags) = 
     case tag of
      TagOpen "TABLE" content -> searchTR days tags
      _ -> table days tags
--
--
--
-- printSlots :: [(String, [(String, [[String]])])] -> String
--printSlots [] = return ()
--printSlots ( (day : days) : slots ) = do
--       print day
--       printSlots (days, slots)
--
--
--
testTable filePath = do 
--        daten <- readL "testHtml2.html"
--        daten <- readL "s_bai6_unix.html"
        daten <- readL filePath
        print $ searchTR (tail (fst $ tableHead $ parseTags daten)) (snd (tableHead (parseTags daten)))
--        print $ printSlots $ searchTR (tail (fst $ tableHead $ parseTags daten)) 
--                                      (snd (tableHead (parseTags daten)))

--    where
--     slots = searchTR (tail (fst $ tableHead $ parseTags daten)) (snd (tableHead (parseTags daten)))
--        print $ (table (tail (fst $ tableHead $ parseTags daten))
--                       (snd (tableHead (parseTags daten))))
--        print "\n"
--        print $ snd (tableHead (parseTags daten))
--
-- testUnit = 
--
--
--
printHead = do
--        daten <- readL "s_bai6_unix.html"
        daten <- readL "testHtml2.html"
        print $ tableHead $ parseTags daten
--
--
printHtml = do 
        daten <- readL "testHtml2.html"
--        daten <- readL "s_bai6_unix.html"
        print $ parseTags daten
--
--
{-
 [TagOpen "TABLE" [("BORDER","1"),("WIDTH","100%"),("cellspacing","0"),("bordercolordark","#FFFFFF")],TagOpen "TR" [("align","center")],TagOpen "TD" [],TagOpen "font" [("color","#A52A2A")],TagText " ",TagOpen "img" [("border","0"),("src","bilder/monitor.gif"),("width","17"),("height","17")],TagText "DBS\160V1",TagOpen "BR" [],TagText "WKST\160",TagOpen "B" [],TagText "g",TagClose "B",TagText "\160\&1",TagOpen "BR" [],TagText "Knolle ",TagClose "font",TagClose "TD",TagOpen "TD" [],TagOpen "font" [("color","#2D71FF")],TagText " ",TagOpen "img" [("border","0"),("src","bilder/monitor.gif"),("width","17"),("height","17")],TagText "DBS\160V1",TagOpen "BR" [],TagText "WKST\160",TagOpen "B" [],TagText "u",TagClose "B",TagText "\160\&2",TagOpen "BR" [],TagText "Knolle ",TagClose "font",TagClose "TD",TagClose "TR",TagText "\r\n",TagOpen "TR" [("align","center")],TagOpen "TD" [],TagOpen "font" [("color","#2D71FF")],TagText " ",TagOpen "img" [("border","0"),("src","bilder/monitor.gif"),("width","17"),("height","17")],TagText "SWEProg\160V3",TagOpen "BR" [],TagText "PC2\160",TagOpen "B" [],TagText "u",TagClose "B",TagText "\160\&1",TagOpen "BR" [],TagText "Braun ",TagClose "font",TagClose "TD",TagOpen "TD" [],TagOpen "font" [("color","#A52A2A")],TagText " ",TagOpen "img" [("border","0"),("src","bilder/monitor.gif"),("width","17"),("height","17")],TagText "SWEProg\160V3",TagOpen "BR" [],TagText "PC2\160",TagOpen "B" [],TagText "g",TagClose "B",TagText "\160\&2",TagOpen "BR" [],TagText "Braun ",TagClose "font",TagClose "TD",TagClose "TR",TagText "\r\n",TagClose "TABLE"] 

[TagOpen "font"     [("color","#A52A2A")],TagText " ",TagOpen "img" [("border","0"),("src","bilder/monitor.gif"),("width","17"),("height","17")],TagText "DBS\160V1",TagOpen "BR" [],TagT    ext "WKST\160",TagOpen "B" [],TagText "g",TagClose "B",TagText "\160\&1",TagOpen "BR" [],TagText "Knolle ",TagClose "font",TagClose "TD"]

-}
--
--
