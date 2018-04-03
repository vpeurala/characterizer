module CharacterizationSpec where

import Control.Exception (evaluate)
import Characterization
import Test.Hspec

spec :: Spec
spec = do
  describe "Characterizer.parseJavaFile" $ do
    it "Can parse a minimal Java file" $ do
      parseResult <- parseJavaFile "test-java-project/src/main/java/MinimalExample.java"
      (show parseResult) `shouldBe` "Right (CompilationUnit Nothing [] [ClassTypeDecl (ClassDecl [public] (Ident \"MinimalExample\") [] Nothing [] (ClassBody []))])"
    it "Can parse a Java file with main" $ do
      parseResult <- parseJavaFile "test-java-project/src/main/java/MainExample.java"
      (show parseResult) `shouldBe` "Right (CompilationUnit Nothing [] [ClassTypeDecl (ClassDecl [public] (Ident \"MainExample\") [] Nothing [] (ClassBody [MemberDecl (MethodDecl [public,static] [] Nothing (Ident \"main\") [FormalParam [] (RefType (ArrayType (RefType (ClassRefType (ClassType [(Ident \"String\",[])]))))) False (VarId (Ident \"args\"))] [ClassRefType (ClassType [(Ident \"Exception\",[])])] Nothing (MethodBody (Just (Block [BlockStmt (ExpStmt (MethodInv (MethodCall (Name [Ident \"System\",Ident \"out\",Ident \"println\"]) [Lit (String \"Hoo vee\")])))]))))]))])"
  describe "Characterizer.parseJavaFiles" $ do
    it "Can parse all examples" $ do
      parseResult <- parseJavaFiles "test"
      case parseResult of
        Right results -> results `shouldNotBe` []
