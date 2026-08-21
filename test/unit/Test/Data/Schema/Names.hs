{-
Copyright 2021 Wire Swiss GmbH

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-}

module Test.Data.Schema.Names where

import Data.Schema hiding (getName)
import Test.Tasty
import Test.Tasty.HUnit

-- TODO: Align these with other imports
-- BEGIN: Imports module replacement
import Data.Text (Text)
-- END

newtype UserId = UserId Text
  deriving (Eq, Show)

newtype Qualified a = Qualified a
  deriving (Eq, Show)

testSchemaNames :: TestTree
testSchemaNames =
  testGroup
    "mkSchemaName"
    [ testSimpleType,
      testSimpleTypeFromStdLib,
      testParameterizedTypeOne,
      testParameterizedTypeTwo,
      testNestedParameterizedType,
      testTupleType,
      testListType
    ]

testSimpleType :: TestTree
testSimpleType =
  testCase "Simple type from current module" $
    assertEqual
      mempty
      "UserId_Mzg3ODM1MzE3"
      (mkSchemaName @UserId)

testSimpleTypeFromStdLib :: TestTree
testSimpleTypeFromStdLib =
  testCase "Simple type from standard library" $
    assertEqual
      mempty
      "Int_Mjg5NjU2NjEw"
      (mkSchemaName @Int)

testParameterizedTypeOne :: TestTree
testParameterizedTypeOne =
  testCase "Parameterized type with one parameter" $ do
    assertEqual
      mempty
      "Maybe_Int_LTg4NDMwMDQ1"
      (mkSchemaName @(Maybe Int))
    assertEqual
      mempty
      "Qualified_UserId_NjA2MzcwNjQ2"
      (mkSchemaName @(Qualified UserId))

testParameterizedTypeTwo :: TestTree
testParameterizedTypeTwo =
  testCase "Parameterized type with two parameters" $
    assertEqual
      mempty
      "Either_Int_UserId_OTAzNzE0MzA4"
      (mkSchemaName @(Either Int UserId))

testNestedParameterizedType :: TestTree
testNestedParameterizedType =
  testCase "Nested parameterized types" $ do
    assertEqual
      mempty
      "Maybe_Qualified_UserId_NjE1MjgxNDQz"
      (mkSchemaName @(Maybe (Qualified UserId)))
    assertEqual
      mempty
      "Qualified_Maybe_Int_LTU0NDY2MjU1"
      (mkSchemaName @(Qualified (Maybe Int)))

testTupleType :: TestTree
testTupleType =
  testCase "Tuple types" $
    assertEqual
      mempty
      "Int_UserId_LTgwNjYzNzA2"
      (mkSchemaName @(Int, UserId))

testListType :: TestTree
testListType =
  testCase "List type" $
    assertEqual
      mempty
      "UserId_LTc0Mjg2NTY2"
      (mkSchemaName @[UserId])
