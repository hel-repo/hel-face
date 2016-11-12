module Base.Input exposing (..)

import Json.Decode as Json


keyDecoder : (Int -> a) -> Json.Decoder a
keyDecoder msg =
  Json.map msg
    <| Json.object1 identity
        (Json.at ["keyCode"] Json.int)
