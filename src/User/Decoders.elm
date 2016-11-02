module User.Decoders exposing (..)

import Json.Decode as Json exposing ((:=), succeed)
import Json.Decode.Extra exposing ((|:))

import User.Models exposing (..)


userDecoder : Json.Decoder User
userDecoder =
  Json.succeed User
    |: ("nickname" := Json.string)
    |: succeed "" -- We do not need this password field anymore, so we can erase it
    |: ("groups" := Json.list Json.string)