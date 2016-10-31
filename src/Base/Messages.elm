module Base.Messages exposing (..)

import Material
import Package.Messages as PMsg
import Package.Models exposing (SearchData)
import User.Messages as UMsg

type Msg
  = Mdl (Material.Msg Msg)
  | RoutePackageList SearchData
  | RoutePackageDetails String
  | RouteAuth
  | PackageMsg PMsg.Msg
  | UserMsg UMsg.Msg