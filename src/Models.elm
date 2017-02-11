module Models exposing (..)

import Routing

import Material
import Material.Snackbar as Snackbar

import Base.Models exposing (Session, emptySession, SnackbarType(..))
import Package.Models exposing (PackageData, emptyPackageData)
import User.Models exposing (UserData, emptyUserData)


type alias Model =
  { mdl : Material.Model
  , snackbar : Snackbar.Model SnackbarType
  , snackbarType: SnackbarType
  , route : Routing.Route
  , session : Session
  , search : String
  , packageData : PackageData
  , userData : UserData
  , logo: String
  }

type alias Flags =
  { logo: String
  }

materialModel : Material.Model
materialModel =
  Material.model

initialModel : Routing.Route -> String -> Model
initialModel route logo =
  { mdl = materialModel
  , snackbar = Snackbar.model
  , snackbarType = Info
  , route = route
  , session = emptySession
  , search = ""
  , packageData = emptyPackageData materialModel
  , userData = emptyUserData materialModel
  , logo = logo
  }
