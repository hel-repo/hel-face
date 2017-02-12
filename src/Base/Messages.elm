module Base.Messages exposing (..)

import Http exposing (Error)
import Navigation exposing (Location)

import Material
import Material.Snackbar as Snackbar

import Base.Helpers.Search exposing (PackagePage)
import Base.Models.Generic exposing (SnackbarType)
import Base.Models.User exposing (User, Session)
import Package.Messages as PMsg
import User.Messages as UMsg


type Msg
  = Mdl (Material.Msg Msg)
  | Snackbar (Snackbar.Msg SnackbarType)
  | UpdateUrl Location
  | SearchBox String
  -- Network
  | ChangeSession Session
  | CheckSession
  | SessionChecked (Result Error Session)
  | UserFetched (Result Error User)
  -- Notifications
  | ErrorOccurred String
  | SomethingOccurred String
  -- Routing
  | Navigate String
  | RoutePackageList PackagePage
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
