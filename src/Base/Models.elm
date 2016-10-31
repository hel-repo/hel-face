module Base.Models exposing (..)

import Material
import Routing

import Package.Models exposing (PackageListData)
import User.Models exposing (UserData)


type alias Model =
  { mdl : Material.Model
  , route : Routing.Route
  , packageData : PackageListData
  , userData : UserData
  }


materialModel : Material.Model
materialModel =
  Material.model

initialModel : Routing.Route -> Model
initialModel route =
  { mdl = materialModel
  , route = route
  , packageData =
      { mdl = materialModel
      , packages = []
      , loading = False
      , version = 0
      , error = ""
      , share = ""
      }
  , userData =
      { mdl = materialModel
      , login = ""
      , password = ""
      , error = ""
      , loading = False
      }
  }
