module Lib
    ( someFunc
    , parseJavaFile
    ) where

import qualified Control.Exception as CE
import qualified Data.Either as DE
import qualified Language.Java.Parser as J
import qualified System.Environment as SE
import qualified System.IO as SI

someFunc :: IO ()
someFunc = do
  args <- SE.getArgs
  parseResult <- parseJavaFile $ args !! 0
  putStrLn $ show parseResult

parseJavaFile fileName = do
  fileContent <- SI.readFile fileName
  let parseResult = J.parser J.compilationUnit fileContent
  return parseResult
