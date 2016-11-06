module Base.Models exposing (..)

import Material
import Routing

import Package.Models exposing (PackageData, emptyPackageData)
import User.Models exposing (UserData, emptyUserData)


type alias Model =
  { mdl : Material.Model
  , route : Routing.Route
  , error : String
  , notification : String
  , search : String
  , packageData : PackageData
  , userData : UserData
  }


materialModel : Material.Model
materialModel =
  Material.model

initialModel : Routing.Route -> Model
initialModel route =
  { mdl = materialModel
  , route = route
  , error = ""
  , notification = ""
  , search = ""
  , packageData =
      emptyPackageData materialModel
  , userData =
      emptyUserData materialModel
  }
