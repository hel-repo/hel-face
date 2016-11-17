module Base.Models exposing (..)

import Time exposing (Time, second)

import Material
import Routing

import Base.Config as Config
import Package.Models exposing (PackageData, emptyPackageData)
import User.Models exposing (UserData, emptyUserData)


type NotificationType = Info | Error

type alias Notification =
  { ntype : NotificationType
  , message : String
  , delay : Time
  }

type alias Model =
  { mdl : Material.Model
  , route : Routing.Route
  , notification : Notification
  , search : String
  , packageData : PackageData
  , userData : UserData
  }


materialModel : Material.Model
materialModel =
  Material.model


emptyNotification =
  { ntype = Info
  , message = ""
  , delay = 0
  }

error : String -> Notification
error message =
  { ntype = Error
  , message = message
  , delay = Config.notificationDelay
  }

info : String -> Notification
info message =
  { ntype = Info
  , message = message
  , delay = Config.notificationDelay
  }


initialModel : Routing.Route -> Model
initialModel route =
  { mdl = materialModel
  , route = route
  , notification = emptyNotification
  , search = ""
  , packageData =
      emptyPackageData materialModel
  , userData =
      emptyUserData materialModel
  }
