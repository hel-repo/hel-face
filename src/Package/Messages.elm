module Package.Messages exposing (..)

import Http exposing (Error)

import Base.Helpers.Search exposing (PackagePage)
import Base.Models.Network exposing (ApiResult)
import Base.Models.Package exposing (Package)


type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | FetchPackages PackagePage
  | PackagesFetched (Result Error PackagePage)
  | NextPage
  | PreviousPage
  | FetchPackage String
  | PackageFetched (Result Error Package)
  | SavePackage Package
  | PackageSaved (Result Error ApiResult)
  | RemovePackage String
  | PackageRemoved (Result Error ApiResult)
  -- Navigation
  | GoToPackageList PackagePage
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
  | ScreenshotLoaded
