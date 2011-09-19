{-# LANGUAGE OverloadedStrings #-}
module TempEventUpload where
--
import Network.HTTP.Enumerator
import Network.HTTP.Types

import qualified Data.ByteString.Lazy as L 
--import Data.ByteString.UTF8
import qualified Data.ByteString.Char8 as B
import qualified Codec.Binary.UTF8.String as BUS
import Text.XML.Light
-- cabal install tls http-enumerator
--
import Network.TLS (TLSCertificateUsage (CertificateUsageAccept))
--
--
--tempEventUpload :: String -> String -> IO L.ByteString
tempEventUpload url bodyDaten = do
  let q = QName "SYSTEM" Nothing Nothing
  let attribs = []
--  let doc = Element {elName=q, elAttribs=attribs, elContent=bodyDaten , elLine=Nothing}

  req0 <- parseUrl $ url
  let req = req0 { method = "PUT"
                 , requestHeaders = [("Content-Type", "application/json")]
--                 , checkCerts = const $ return CertificateUsageAccept
--                 , requestBody = RequestBodyBS $ fromString $ showTopElement doc
--                 , requestBody = RequestBodyBS $ fromString $ bodyDaten
                 , requestBody = RequestBodyLBS (L.pack (BUS.encode bodyDaten))
                 }
  res <- withManager $ httpLbs req
--  L.putStrLn $ responseBody res
  return $ responseBody res
--
--

--
--
{-
main = do
  events <- getEventsFromRest "https://212.201.64.226:8443/fhs-spirit/event" 
  L.putStrLn events
  L.writeFile "events.json" events 
-}
--
