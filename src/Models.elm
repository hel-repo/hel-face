module Models exposing (..)

import List exposing (length, map)

import Material


type alias Package =
  { name : String
  , description : String
  , short_description : String
  , owners : List String
  , authors : List String
  , tags : List String
  }

type alias Model =
  { mdl: Material.Model
  , selectedTab : Int
  , loading : Bool
  , error : String
  , packages : List Package
  }

-- Initial data
model : Model
model =
  { mdl = Material.model
  , selectedTab = 0
  , loading = False
  , error = ""
  , packages = []
  }