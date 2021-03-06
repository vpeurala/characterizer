module Characterization
    ( main
    , parseJavaFile
    , parseJavaFiles
    ) where

import qualified Control.Exception as CE
import qualified Control.Monad as CM
import qualified Data.Either as DE
import qualified Data.Strings as DS
import qualified Language.Java.Parser as J
import qualified Language.Java.Syntax as J
import qualified System.Directory as SD
import qualified System.Environment as SE
import qualified System.IO as SI
import qualified Text.Parsec.Error as PE

import Debug.Trace

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
parseJavaFiles rootDir = do
  results <- handleEntry rootDir "."
  let lefts = DE.lefts results
  if null lefts
  then return $ DE.Right $ DE.rights results
  else return $ DE.Left lefts
  where recurseDirs :: FilePath -> IO [Either PE.ParseError J.CompilationUnit]
        recurseDirs dir = do
          entries <- SD.listDirectory dir
          --putStrLn ("entries: " ++ show entries)
          let filteredEntries = filter (`notElem` [".", ".."]) entries
          --putStrLn ("filtered entries: " ++ show filteredEntries)
          mappedEntries <- CM.mapM (handleEntry dir) filteredEntries
          --putStrLn ("mapped entries: " ++ show mappedEntries)
          return $ concat mappedEntries
        handleEntry :: FilePath -> FilePath -> IO [Either PE.ParseError J.CompilationUnit]
        -- TODO Remove tracing and putStrLn output
        handleEntry dir entry = do
          --putStrLn ("In handleEntry for entry: " ++ show entry)
          isDir <- SD.doesDirectoryExist (dir ++ "/" ++ entry)
          --putStrLn ("isDir for entry " ++ (dir ++ "/" ++ entry) ++ ": " ++ show isDir)
          if isDir
            then do
            --putStrLn "Was directory"
            recurseDirs (dir ++ "/" ++ entry)
          else if DS.strEndsWith entry ".java"
            then do
            --putStrLn "Was Java file"
            sequence $ [parseJavaFile (dir ++ "/" ++ entry)]
          else do
            --putStrLn "Returning sequence []"
            sequence []
