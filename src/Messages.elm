module Messages exposing (..)

import Material
import Package.Models exposing (Package)

type Msg
  = Mdl (Material.Msg Msg)
  | SelectTab Int
  | FetchPackages
  | ErrorOccurred String
  | PackagesFetched (List Package)