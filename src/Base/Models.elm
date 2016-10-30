module Base.Models exposing (..)

import Material
import Routing

import Package.Models exposing (PackageListData)


type alias Model =
  { mdl : Material.Model
  , route : Routing.Route
  , packageData : PackageListData
  }


materialModel : Material.Model
materialModel =
  Material.model

initialModel : Routing.Route -> Model
initialModel route =
  { mdl = materialModel
  , route = route
  , packageData = { packages = [], loading = False, version = 0, error = "", share = "" }
  }
