module Base.Models exposing (..)

import Material
import Routing

import Package.Models exposing (PackageListData)


type alias Model =
  { mdl : Material.Model
  , route : Routing.Route
  , list : PackageListData
  , selectedTab : Int
  }


materialModel : Material.Model
materialModel =
  Material.model

initialModel : Routing.Route -> Model
initialModel route =
  { mdl = materialModel
  , route = route
  , list = { packages = [], loading = False, error = "" }
  , selectedTab = 0
  }