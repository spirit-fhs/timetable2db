module TestMongoDaten where
--
import Data.ByteString.Lazy (ByteString, toChunks, readFile)
import Data.ByteString.Lazy.UTF8 (lines, toString, fromString)
--
testDaten = do
 daten <- Data.ByteString.Lazy.readFile "mongodb_bkp_fhsdozent.json"
 putStrLn $ toString daten
 writeFile "copyMongo.json" $ toString daten
--
