module Models exposing (..)

import Material
import Routing
import Time exposing (Time, second)

import Base.Config as Config
import Base.Models exposing (Session, emptySession)
import Package.Models exposing (PackageData, emptyPackageData)
import User.Models exposing (UserData, emptyUserData)


type NotificationType = Info | Error

type alias Notification =
  { ntype : NotificationType
  , message : String
  , delay : Time
  }

emptyNotification : Notification
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


type alias Model =
  { mdl : Material.Model
  , route : Routing.Route
  , session : Session
  , notification : Notification
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
  , route = route
  , session = emptySession
  , notification = emptyNotification
  , search = ""
  , packageData = emptyPackageData materialModel
  , userData = emptyUserData materialModel
  , logo = logo
  }
