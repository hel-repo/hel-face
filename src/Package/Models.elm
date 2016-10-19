module Package.Models exposing (..)

type alias Package =
  { name : String
  , description : String
  , short_description : String
  , owners : List String
  , authors : List String
  , tags : List String
  }