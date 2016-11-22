module Package.Messages exposing (..)

import Http exposing (Error)

import Base.Models exposing (ApiResult, Package)
import Base.Search exposing (SearchData)


type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | FetchPackages SearchData
  | PackagesFetched (Result Error (List Package))
  | FetchPackage String
  | PackageFetched (Result Error Package)
  | SavePackage Package
  | PackageSaved (Result Error ApiResult)
  | RemovePackage String
  | PackageRemoved (Result Error ApiResult)
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
  | InputOwner String
  | RemoveOwner String
  | InputAuthor String
  | RemoveAuthor String
  | InputContent String
  | RemoveContent String
  | AddVersion
  | RemoveVersion
  | InputVersion String
  | InputChanges String
  | InputFilePath Int String
  | InputFileName Int String
  | InputFileUrl Int String
  | AddFile
  | RemoveFile Int
  | InputDependencyName Int String
  | InputDependencyVersion Int String
  | AddDependency
  | RemoveDependency Int
  | InputScreenshotUrl Int String
  | InputScreenshotDescription Int String
  | AddScreenshot
  | RemoveScreenshot Int
  | InputKey Int
  -- Other
  | SharePackage String
  | PreviousScreenshot
  | NextScreenshot
