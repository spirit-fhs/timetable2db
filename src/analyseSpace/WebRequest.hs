{-# LANGUAGE OverloadedStrings #-}
module WebRequest where
--
import Network.Socket
import Network.HTTP.Enumerator
import Network.HTTP.Types
import qualified Data.ByteString.Lazy.UTF8 as BSLU
--
--
requestHTML addr = withSocketsDo $ do
    req0 <- parseUrl addr
    let req = req0 { method = methodGet }
    res <- withManager $ httpLbs req
    return $ BSLU.toString $ responseBody res
--
