module Base.Messages exposing (..)

import Material
import Package.Messages as PMsg
import Package.Models exposing (SearchData)
import User.Messages as UMsg

type Msg
  = Mdl (Material.Msg Msg)
  | ErrorOccurred String
  | SomethingOccurred String
  | DismissNotification
  | Navigate String
  | RoutePackageList SearchData
  | RoutePackageDetails String
  | RoutePackageEdit String
  | RouteAuth
  | RouteRegister
  | RouteProfile
  | InputSearch String
  | InputKey Int
  | PackageMsg PMsg.Msg
  | UserMsg UMsg.Msg