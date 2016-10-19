module Models exposing (..)

import Material

import Package.Models exposing (PackageListData)


type alias Model =
  { mdl: Material.Model
  , list: PackageListData
  , selectedTab : Int
  }


initialModel : Model
initialModel =
  { mdl = Material.model
  , list = { packages = [], loading = False, error = "" }
  , selectedTab = 0
  }