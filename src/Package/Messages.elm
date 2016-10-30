module Package.Messages exposing (..)

import Package.Models exposing (Package, SearchData)

type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | FetchPackages SearchData
  | PackagesFetched (List Package)
  | FetchPackage String
  | PackageFetched Package
  -- Navigation
  | GoToPackageList SearchData
  | GoToPackageDetails String
  | GoToVersion Int
  -- Other
  | SharePackage String