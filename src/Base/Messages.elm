module Base.Messages exposing (..)

import Http exposing (Error)
import Material
import Navigation exposing (Location)
import Time exposing (Time)

import Base.Models exposing (Session, User)
import Base.Search exposing (SearchData)
import Package.Messages as PMsg
import User.Messages as UMsg


type Msg
  = Mdl (Material.Msg Msg)
  | Tick Time
  | UpdateUrl Location
  -- Network
  | CheckSession
  | SessionChecked (Result Error Session)
  | UserFetched (Result Error User)
  -- Notifications
  | ErrorOccurred String
  | SomethingOccurred String
  | DismissNotification
  -- Routing
  | Navigate String
  | RoutePackageList SearchData
  | RoutePackageDetails String
  | RoutePackageEdit String
  | RouteAuth
  | RouteRegister
  | RouteProfile
  | RouteAbout
  | Back
  -- Input
  | InputSearch String
  | InputKey Int
  -- Modules communication
  | PackageMsg PMsg.Msg
  | UserMsg UMsg.Msg
