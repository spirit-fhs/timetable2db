module Transformer.TestListToIS where
--
import Test.QuickCheck
--
import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit
--
--
import HtmlToListV2
--
--
main :: IO ()
main = defaultMain tests
--
tests = [ testGroup "HUnit Tests in TestHtmlToListV2 - tableList'"
          [ testCase "Test test_tableList'_Test1" test_tableList'_Test1
          ]
        ]
--
--
-- test_rentable = assertBool "moop" ("Hallo" == "Hallo")
--
--
{-
test_tableList'_Test1 = assertBool "Test1: " 
                           ( tableList' "<TABLE> 
                                          <TR> <TH> test </TH> </TR> 
                                          <TR> <TD> 08.15-09.15 </TD> 
                                               <TD> <TABLE> <TR> <TD> TEST </TD> </TR> </TABLE> </TD> 
                                          </TR> 
                                         </TABLE>"
                             == 
                           )
-}
--
--
