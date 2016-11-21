module User.Decoders exposing (..)

import Json.Decode as Json exposing (field, succeed, oneOf)
import Json.Decode.Extra exposing ((|:))

import User.Models exposing (..)


profileDecoder : Json.Decoder Profile
profileDecoder =
  Json.succeed Profile
    |: (field "success" Json.bool)
    |: oneOf [ Json.at ["data"] <| field "nickname" Json.string, succeed "" ]
    |: oneOf [ field "logged_in" Json.bool, succeed False ]
    |: (field "version" Json.string)

userDecoder : Json.Decoder User
userDecoder =
  Json.succeed User
    |: (field "nickname" Json.string)
    |: succeed "" -- We do not need this password field anymore, so we can erase it
    |: succeed "" -- Same for "retry password" field
    |: succeed "" -- Same for email
    |: (field "groups" <| Json.list Json.string)

singleUserDecoder : Json.Decoder User
singleUserDecoder =
  Json.at ["data"] userDecoder
