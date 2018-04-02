module Characterization
    ( main
    , parseJavaFile
    , parseJavaFiles
    ) where

import qualified Control.Exception as CE
import qualified Control.Monad as CM
import qualified Data.Either as DE
import qualified Data.String.Utils as DSU
import qualified Language.Java.Parser as J
import qualified Language.Java.Syntax as J
import qualified System.Directory as SD
import qualified System.Environment as SE
import qualified System.IO as SI
import qualified Text.Parsec.Error as PE

main :: IO ()
main = do
  args <- SE.getArgs
  parseResult <- parseJavaFiles $ args !! 0
  putStrLn $ show parseResult

parseJavaFile :: FilePath -> IO (Either PE.ParseError J.CompilationUnit)
parseJavaFile fileName = do
  fileContent <- SI.readFile fileName
  let parseResult = J.parser J.compilationUnit fileContent
  return parseResult

parseJavaFiles :: FilePath -> IO (Either [PE.ParseError] [J.CompilationUnit])
parseJavaFiles dir = do
  results <- recurseDirs dir
  let lefts = DE.lefts results
  if null lefts
  then return $ DE.Right $ DE.rights results
  else return $ DE.Left lefts
  where recurseDirs :: FilePath -> IO [Either PE.ParseError J.CompilationUnit]
        recurseDirs dir = do
          entries <- SD.listDirectory dir
          let filteredEntries = filter (`notElem` [".", ".."]) entries
          mappedEntries <- CM.mapM handleEntry filteredEntries
          return $ concat mappedEntries
        handleEntry :: FilePath -> IO [Either PE.ParseError J.CompilationUnit]
        handleEntry entry = do
          isDir <- SD.doesDirectoryExist entry
          if isDir
          then recurseDirs entry
          else if entry `DSU.endswith` ".java"
          then sequence $ [parseJavaFile entry]
          else return []