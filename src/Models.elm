module Models exposing (..)

import Material

import Package.Models exposing (Package)


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