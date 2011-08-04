{-# LANGUAGE OverloadedStrings #-}
module HaxmlTest where
--
--
import qualified Text.XML.HaXml.Html.Parse as XML
--
import Text.XML.HaXml.Html.Pretty
--
import WebRequest
--
--
testHaxml = do
  daten <- requestHTML "http://sund.de/steffen/plan/s_bai6.html"
--  print $ document $ XML.htmlParse "test" "<html> </html>"
  print $ document $ XML.htmlParse "test" daten
--  test <- XML.htmlParse "s_bai6.html" "test"
--  print $ XML.htmlParse "s_bai6.html" "test"
  print "ende"
--
--
