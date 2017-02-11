module Base.Messages exposing (..)

import Http exposing (Error)
import Navigation exposing (Location)

import Material
import Material.Snackbar as Snackbar

import Base.Models exposing (Session, SnackbarType, User)
import Base.Search exposing (SearchData)
import Package.Messages as PMsg
import User.Messages as UMsg


type Msg
  = Mdl (Material.Msg Msg)
  | Snackbar (Snackbar.Msg SnackbarType)
  | UpdateUrl Location
  | UpdateSession Session
  -- Network
  | CheckSession
  | SessionChecked (Result Error Session)
  | UserFetched (Result Error User)
  -- Notifications
  | ErrorOccurred String
  | SomethingOccurred String
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
