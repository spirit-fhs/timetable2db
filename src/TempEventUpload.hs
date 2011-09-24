{-# LANGUAGE OverloadedStrings #-}
module TempEventUpload where
--
import Network.HTTP.Enumerator
import Network.HTTP.Types
--import Network.Browser
--
import qualified Data.ByteString.Lazy as L 
--import Data.ByteString.UTF8
import qualified Data.ByteString.Char8 as B
import qualified Codec.Binary.UTF8.String as BUS
import Text.XML.Light
-- cabal install tls http-enumerator
import qualified Codec.Binary.Base64.String as Base64
import qualified Data.ByteString.Lazy.UTF8 as BSLU
--
import Network.TLS (TLSCertificateUsage (CertificateUsageAccept))
--
--
-- user: schedule
-- pass: piepmatz
--
--tempEventUpload :: String -> String -> IO L.ByteString
tempEventUpload url bodyDaten = do
  let q = QName "SYSTEM" Nothing Nothing
  let attribs = []
--  let doc = Element {elName=q, elAttribs=attribs, elContent=bodyDaten , elLine=Nothing}

  req0 <- parseUrl $ url
  let req = req0 { method = "PUT"
                 , requestHeaders = [ ("Content-Type", "application/json")
                                    , ("Authorization", (B.pack ("Basic " ++ (Base64.encode "schedule:piepmatz"))))
                                    ]
--                 , checkCerts = const $ return CertificateUsageAccept
--                 , requestBody = RequestBodyBS $ fromString $ showTopElement doc
--                 , requestBody = RequestBodyBS $ fromString $ bodyDaten
--                 , requestBody = RequestBodyLBS (L.pack (BUS.encode bodyDaten))
                 , requestBody = RequestBodyLBS bodyDaten
                 }
--    where 
--     auth = "Basic " ++ (encode "schedule:piepmatz")
  res <- withManager $ httpLbs req
--  L.putStrLn $ responseBody res
--  return $ responseBody res
  return res
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
