module HtmlToList ( testTableByFile
                  , tableList 
                  ) where
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
-- readL :: FilePath -> IO String
-- readL file = readFile file
--
--
-- | Read the head of the table.
--  In the table the head includes the days of the week.
tableHead :: [Tag [Char]] -> ([String], [Tag String])
tableHead (tag : tags) =
     case tag of
      TagOpen "TH" content -> ((((tableText' tags) : (fst (tableHead tags)))), (snd (tableHead tags)))
      TagClose "TR" -> ([], tags)
      _ -> tableHead tags
--
-- | Search one text element.
tableText' (tag : tags) =
     case tag of
      TagText text -> text
      TagClose "TD" -> []
      _ -> tableText' tags
--
-- ==============================================================================
--
-- | Search the time of the table line.
findTime (tag : tags) =
     case tag of
      TagOpen "TD" content -> ((tableText' tags), tags)
      TagClose "TD" -> ([], tags)
      _ -> findTime tags
--
--
{-
filterTextSymbols :: String -> String
filterTextSymbols [] = []
filterTextSymbols ( '\160' : symbols ) = ' '    : (filterTextSymbols symbols)
filterTextSymbols ( symbol : symbols ) = symbol : (filterTextSymbols symbols)
-}
filterTextSymbols :: String -> String
filterTextSymbols = map replace
  where replace '\160' = ' '
        replace x = x
--
--
tableTDText (tag : tags) =
     case tag of
--      TagText text -> ((text : (fst (tableTDText tags))), (snd (tableTDText tags)))
      TagText text -> (((filterTextSymbols text) : (fst (tableTDText tags))), (snd (tableTDText tags)))
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
      _ -> readSlots days tags
   where 
    rek = (readSlots days (snd (tableTDText tags)))
--
--
tableTD :: [String] -> [Tag String] -> ([[String]], [Tag String])
tableTD days (tag : tags) =
     case tag of
      -- ^ Rekursion ist hier erforderlich, da bis zum /TD gelesen werden muss, dass nach dem /TABLE kommt.
      -- Sonst passiert es das Zeichen doppelt gelesen werden.
      TagOpen "TABLE" content -> (((fst rek) ++ (fst td)), (snd td))
      TagClose "TD" -> ([], tags)
      _ -> tableTD days tags
   where
    rek = readSlots days tags
    td  = tableTD days (snd rek)
--
--
tableTR :: [String] -> [Tag String] -> ([(String, [[String]])], [Tag String])
tableTR days (tag : tags) =
     case tag of
      -- ^ Baut ein Tuppel das den Tag und die Liste von Slots beinhaltet, die an diesem Tag statt finden.
      TagOpen  "TD" content -> ((((head days), (fst td)) : (fst tr)), 
                                (snd tr))
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
searchTR days (tag : tags) =
     case tag of
      TagOpen "TR" content -> ((( time, slot) : (fst rekursion)), ( snd rekursion ))
      TagClose "TABLE" -> ([], tags)  -- ^ Fuer den fall, dass ein sauberes ende vollzogen werden kann.
      _ -> searchTR days tags
    where
     time     = fst $ findTime tags
     (slot, restPars ) = skipFirstTD days tags
     rekursion = searchTR days restPars
--
--
--
tableList :: String -> [(String, [(String, [[String]])])]
tableList daten = fst $ searchTR (tail (fst $ tableHead $ parseTags daten)) (snd (tableHead (parseTags daten)))
--
--
testTableByFile filePath = do 
--        daten <- readL "testHtml2.html"
--        daten <- readL "s_bai6_unix.html"
        daten <- readFile filePath
--        daten <- readL filePath
        print $ searchTR (tail (fst $ tableHead $ parseTags daten)) (snd (tableHead (parseTags daten)))
--
--
printHead = do
--        daten <- readL "s_bai6_unix.html"
        daten <- readFile "testHtml2.html"
--        daten <- readL "testHtml2.html"
        print $ tableHead $ parseTags daten
--
--
printHtml = do 
--        daten <- readFile "testHtml2.html"
--        daten <- readL "testHtml2.html"
        daten <- readFile "../vorlage/s_bai6_unix.html"
        print $ parseTags daten
--
--
--
