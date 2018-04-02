import Control.Exception (evaluate)
import Lib
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "Characterizer.parseJavaFile" $ do
    it "Can parse a minimal Java file" $ do
      parseResult <- parseJavaFile "test/MinimalExample.java"
      (show parseResult) `shouldBe` "Right (CompilationUnit Nothing [] [ClassTypeDecl (ClassDecl [public] (Ident \"MinimalExample\") [] Nothing [] (ClassBody []))])"
