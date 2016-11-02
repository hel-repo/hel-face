module User.Decoders exposing (..)

import Json.Decode as Json exposing ((:=), succeed, oneOf)
import Json.Decode.Extra exposing ((|:))

import User.Models exposing (..)


profileDecoder : Json.Decoder Profile
profileDecoder =
  Json.succeed Profile
    |: ("success" := Json.bool)
    |: oneOf [ Json.at ["data"] ("nickname" := Json.string), succeed "" ]
    |: oneOf [ "logged_in" := Json.bool, succeed False ]

userDecoder : Json.Decoder User
userDecoder =
  Json.succeed User
    |: ("nickname" := Json.string)
    |: succeed "" -- We do not need this password field anymore, so we can erase it
    |: ("groups" := Json.list Json.string)
