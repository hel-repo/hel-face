module Base.Messages exposing (..)

import Material
import Package.Messages as PMsg
import Package.Models exposing (SearchData)

type Msg
  = Mdl (Material.Msg Msg)
  | RoutePackageList SearchData
  | RoutePackageDetails String
  | PackageMsg PMsg.Msg