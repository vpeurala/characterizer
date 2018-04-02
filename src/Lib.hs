module Lib
    ( someFunc
    ) where

import qualified Data.Either as E
import qualified Language.Java.Parser as J
import qualified System.Environment as SE
import qualified System.IO as SI

someFunc :: IO ()
someFunc = do
  args <- SE.getArgs
  fileContent <- SI.readFile (args !! 0)
  let parseResult = J.parser J.compilationUnit fileContent
  case parseResult of
    E.Left error -> putStrLn $ "Error: " ++ show error
    E.Right compilationUnit -> putStrLn $ "CompilationUnit: " ++ show compilationUnit
  putStrLn "Something parsed!"
