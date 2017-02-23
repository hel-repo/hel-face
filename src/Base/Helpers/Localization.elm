module Base.Helpers.Localization exposing (..)

import List exposing (map, map2, head)
import Regex exposing (find, split, regex, HowMany(..))
import String exposing (join)


localeAware : String -> String -> String
localeAware lang text =
  let
    raw = map .submatches <| find All ( regex "<(..)>" ) text
    maybeTags = map ( (Maybe.withDefault <| Just("--")) << head ) raw
    tags = "--" :: ( map (Maybe.withDefault "--") maybeTags )
    parts = split All ( regex "<..>" ) text
    filtered = map2 ( \tag part -> if tag == "--" || tag == lang then part else "" ) tags parts
  in
    join "" filtered
