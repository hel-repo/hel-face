module Base.Input exposing (..)

import Json.Decode as Json


keyDecoder : (Int -> a) -> Json.Decoder a
keyDecoder msg =
  Json.map msg
    <| Json.map identity (Json.at ["keyCode"] Json.int)
