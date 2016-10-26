module Base.Messages exposing (..)

import Material
import Package.Messages as PMsg

type Msg
  = Mdl (Material.Msg Msg)
  | RoutePackageList
  | RoutePackageDetails String
  | PackageMsg PMsg.Msg