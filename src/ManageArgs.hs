module ManageArgs where
--
import System.Environment
import Text.Printf
--
data Parameter = Source   {name::FilePath}
               | Class    {name::String}
               | Target   {path::FilePath}
               | Help     {msg::String}
           deriving (Show)
--
helpMessage = "Help:\n"
           ++ " -i -> Input file"
           ++ " -c -> Class name for the time table"
           ++ " -o -> Output folder for the parsed time table"
           ++ " -h -> Print this help message"
--
analyseParameter [] = []
analyseParameter ( "-i" : fileName  : args ) = (Source  {name=fileName})  : (analyseParameter args)
analyseParameter ( "-c" : className : args ) = (Class   {name=className}) : (analyseParameter args)
analyseParameter ( "-o" : target    : args ) = (Target  {path=target})    : (analyseParameter args)
--analyseParameter ( "-h" : args )             = (Help    {msg=helpMessage}): (analyseParameter args)
analyseParameter ( "-h" : args )             = [Help    {msg=helpMessage}]
analyseParameter (_ : args) = analyseParameter args
--
-- searchParameter :: Parameter -> String
-- searchParameter parameter = 
--
getArg :: String -> [Parameter] -> String
getArg haveTo parameters = 
  case haveTo of
   "Input" -> 
--
