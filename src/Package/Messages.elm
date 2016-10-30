module Package.Messages exposing (..)

import Package.Models exposing (Package)

type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | FetchPackages
  | PackagesFetched (List Package)
  | FetchPackage String
  | PackageFetched Package
  -- Navigation
  | GoToPackageList
  | GoToPackageDetails String
  | GoToVersion Int
  -- Other
  | SharePackage String