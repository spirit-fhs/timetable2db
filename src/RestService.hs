module RestService where
--
-- http-wget
import Network.HTTP.Wget

--main = putStrLn =<< wget "https://www.google.com" [] []
main = putStrLn =<< wget "https://212.201.64.226:8443/fhs-spirit/event" [] []
--
--
