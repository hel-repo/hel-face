module Package.Messages exposing (..)

import Http exposing (Response)

import Package.Models exposing (Package, SearchData)


type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | FetchPackages SearchData
  | PackagesFetched (List Package)
  | FetchPackage String
  | PackageFetched Package
  | SavePackage Package
  | PackageSaved Response
  -- Navigation
  | GoToPackageList SearchData
  | GoToPackageDetails String
  | GoToPackageEdit String
  | GoToVersion Int
  -- Input
  | InputName String
  | InputLicense String
  | InputDescription String
  | InputShortDescription String
  -- Other
  | SharePackage String