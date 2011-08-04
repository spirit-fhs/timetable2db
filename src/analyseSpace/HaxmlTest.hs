 {-# LANGUAGE OverloadedStrings #-}
module HaxmlTest where
--
import Network.Socket
import Network.HTTP.Enumerator
import Network.HTTP.Types
import qualified Data.ByteString.Lazy.UTF8 as BSLU
--
import qualified Text.XML.HaXml.Html.Parse as XML
--
--
requestHTML addr = withSocketsDo $ do
    req0 <- parseUrl addr
    let req = req0 { method = methodGet }
    res <- withManager $ httpLbs req
    return $ BSLU.toString $ responseBody res
--
--
testHaxml = do
  daten <- requestHTML "http://sund.de/steffen/plan/s_bai6.html"
  XML.htmlParse "test" daten
--  test <- XML.htmlParse "s_bai6.html" "test"
--  print $ XML.htmlParse "s_bai6.html" "test"
--
--
