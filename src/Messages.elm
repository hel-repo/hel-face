module Messages exposing (..)

import Material
import Package.Models exposing (Package)
import Package.Messages

type Msg
  = Mdl (Material.Msg Msg)
  | PackageMsg Package.Messages.Msg
  | SelectTab Int
  | FetchPackages
  | ErrorOccurred String
  | PackagesFetched (List Package)