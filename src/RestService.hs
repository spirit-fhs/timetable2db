{-# LANGUAGE OverloadedStrings #-}
module RestService where
--
import Network.HTTP.Enumerator
import Network.HTTP.Types
import qualified Data.ByteString.Lazy as L

-- cabal install tls http-enumerator
--
import Network.TLS (TLSCertificateUsage (CertificateUsageAccept))
--
--
getEventsFromRest :: String -> IO L.ByteString
getEventsFromRest url = do
  req0 <- parseUrl $ url
  let req = req0 { method = methodGet
                 , requestHeaders = [("Accept", "application/json")]
                 , checkCerts = const $ return CertificateUsageAccept
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
