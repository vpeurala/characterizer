import Control.Exception (evaluate)
import Lib
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "Characterizer.parseJavaFile" $ do
    it "Can parse a minimal Java file" $ do
      parseResult <- parseJavaFile "test/Foo.java"
      (show parseResult) `shouldBe` "Right (CompilationUnit Nothing [] [ClassTypeDecl (ClassDecl [public] (Ident \"Foo\") [] Nothing [] (ClassBody []))])"
