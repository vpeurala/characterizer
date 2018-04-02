module Characterization
    ( main
    , parseJavaFile
    ) where

import qualified Control.Exception as CE
import qualified Data.Either as DE
import qualified Language.Java.Parser as J
import qualified Language.Java.Syntax as J
import qualified System.Environment as SE
import qualified System.IO as SI
import qualified Text.Parsec.Error as PE

main :: IO ()
main = do
  args <- SE.getArgs
  parseResult <- parseJavaFile $ args !! 0
  putStrLn $ show parseResult

parseJavaFile :: String -> IO (Either PE.ParseError J.CompilationUnit)
parseJavaFile fileName = do
  fileContent <- SI.readFile fileName
  let parseResult = J.parser J.compilationUnit fileContent
  return parseResult
