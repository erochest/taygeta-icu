{-# LANGUAGE OverloadedStrings #-}


module Taygeta.TokenizerSpec where


import qualified Data.Text             as T

import           Test.Hspec

import           Taygeta.ICU.Tokenizer


spec :: Spec
spec = do
    describe "treebankTokenizer" $ do
        it "should split standard contractions." $ do
            treebankTokenizer "don't" `shouldBe` ["do", "n't"]
            treebankTokenizer "they'll" `shouldBe` ["they", "'ll"]
        it "should treat most punctuation characters as separate tokens." $
            treebankTokenizer "hello! how are you?" `shouldBe`
                ["hello", "!", "how", "are", "you", "?"]
        it "should split off commas and single quotes when followed by whitespace." $
            treebankTokenizer "'hello,' jackie." `shouldBe`
                ["'hello", ",", "'", "jackie", "."]
        it "should separate periods that appear at the end of a line." $
            treebankTokenizer "this is the doctor." `shouldBe`
                ["this", "is", "the", "doctor", "."]
        it "should not separate periods within a line." $
            treebankTokenizer "the dr. is in." `shouldBe`
                ["the", "dr.", "is", "in", "."]
        it "should tokenize some examples." $ do
            treebankTokenizer "Good muffins cost $3.88\n\
                              \in New York.  Please buy me\n\
                              \two of them.\nThanks.\n" `shouldBe`
                ["Good", "muffins", "cost", "$", "3.88", "in", "New", "York.",
                 "Please", "buy", "me", "two", "of", "them.", "Thanks", "."]
            treebankTokenizer "They'll save and invest more." `shouldBe`
                ["They", "'ll", "save", "and", "invest", "more", "."]

    describe "regexTokenizer" $ do
        it "should identify everything that matches a regex." $
            let tokenizer = regexTokenizer "\\p{L}[\\p{L}\\p{P}]*\\p{L}"
            in  tokenizer "Good muffins cost $3.88\n\
                          \in New York.  Please buy me\n\
                          \two of them.\nThanks.\n" `shouldBe`
                ["Good", "muffins", "cost", "in", "New", "York",
                 "Please", "buy", "me", "two", "of", "them", "Thanks"]
