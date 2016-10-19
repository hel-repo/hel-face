module Package.Messages exposing (..)

import Package.Models exposing (Package)

type Msg
  = NoOp
  | FetchPackages
  | ErrorOccurred String
  | PackagesFetched (List Package)