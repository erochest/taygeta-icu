module Taygeta.ICU.Tokenizer
    ( treebankTokenizer
    , regexTokenizer
    , regexTokenizer'
    ) where


import           Data.Maybe
import qualified Data.Text               as T
import           Data.Text.ICU

import           Taygeta.Parser.Treebank
import           Taygeta.Types


treebankTokenizer :: PlainTokenizer
treebankTokenizer = treebank

regexTokenizer :: T.Text -> PlainTokenizer
regexTokenizer re = regexTokenizer' (regex [UnicodeWord] re)

regexTokenizer' :: Regex -> PlainTokenizer
regexTokenizer' re = mapMaybe (group 0) . findAll re
