module Base.Decoders exposing (..)

import Json.Decode as Json exposing (field, oneOf, succeed)
import Json.Decode.Extra exposing ((|:))

import Base.Models exposing (..)


-- Global state related models
-----------------------------------------------------------------------------------
sessionDecoder : Json.Decoder Session
sessionDecoder =
  Json.succeed Session
    |: (Json.succeed userByName |: oneOf [ Json.at ["data"] <| field "nickname" Json.string, succeed "" ])
    |: oneOf [ field "logged_in" Json.bool, succeed False ]
    |: (field "version" Json.string)


-- User related models
-----------------------------------------------------------------------------------
userDecoder : Json.Decoder User
userDecoder =
  Json.succeed User
    |: (field "nickname" Json.string)
    |: succeed "" -- We do not need this password field anymore, so we can erase it
    |: succeed "" -- Same for "retry password" field
    |: succeed "" -- Same for email
    |: (field "groups" <| Json.list Json.string)

usersDecoder : Json.Decoder (List User)
usersDecoder =
  Json.at ["data", "list"] <| Json.list userDecoder

singleUserDecoder : Json.Decoder User
singleUserDecoder =
  Json.at ["data"] userDecoder


-- Package related modelds
-----------------------------------------------------------------------------------
pkgScreenshotList : List (String, String) -> Json.Decoder (List Screenshot)
pkgScreenshotList list =
  Json.succeed (List.map (\(url, desc) -> Screenshot url desc) list)

screenshots : Json.Decoder (List Screenshot)
screenshots =
  Json.keyValuePairs Json.string |> Json.andThen pkgScreenshotList

pkgVersionFileData : Json.Decoder PkgVersionFileData
pkgVersionFileData =
  Json.succeed PkgVersionFileData
    |: (field "dir" Json.string)
    |: (field "name" Json.string)

pkgVersionFilesList : List (String, PkgVersionFileData) -> Json.Decoder (List VersionFile)
pkgVersionFilesList list =
  Json.succeed (List.map (\(url, data) -> VersionFile url data.dir data.name False) list)

pkgVersionFiles : Json.Decoder (List VersionFile)
pkgVersionFiles =
  Json.keyValuePairs pkgVersionFileData |> Json.andThen pkgVersionFilesList

pkgVersionDependencyData : Json.Decoder PkgVersionDependencyData
pkgVersionDependencyData =
  Json.succeed PkgVersionDependencyData
    |: (field "type" Json.string)
    |: (field "version" Json.string)

pkgVersionDependencyList : List (String, PkgVersionDependencyData) -> Json.Decoder (List VersionDependency)
pkgVersionDependencyList list =
  Json.succeed (List.map (\(name, data) -> VersionDependency name data.deptype data.version False) list)

pkgVersionDependencies : Json.Decoder (List VersionDependency)
pkgVersionDependencies =
  Json.keyValuePairs pkgVersionDependencyData |> Json.andThen pkgVersionDependencyList

pkgVersionData : Json.Decoder PkgVersionData
pkgVersionData =
  Json.succeed PkgVersionData
    |: (field "files" pkgVersionFiles)
    |: (field "depends" pkgVersionDependencies)
    |: (field "changes" Json.string)

pkgVersionList : List (String, PkgVersionData) -> Json.Decoder (List Version)
pkgVersionList list =
  Json.succeed (List.map (\(version, data) -> Version version data.files data.depends data.changes False) list)

version : Json.Decoder (List Version)
version =
  Json.keyValuePairs pkgVersionData |> Json.andThen pkgVersionList

pkgStatsDate : Json.Decoder PkgStatsDate
pkgStatsDate =
  Json.succeed PkgStatsDate
    |: (field "created" Json.string)
    |: (field "last-updated" Json.string)

stats : Json.Decoder Stats
stats =
  Json.succeed Stats
    |: (field "views" Json.int)
    |: (field "date" pkgStatsDate)

packageDecoder : Json.Decoder Package
packageDecoder =
  Json.succeed Package
    |: (field "name" Json.string)
    |: (field "description" Json.string)
    |: (field "short_description" Json.string)
    |: (field "owners" <| Json.list Json.string)
    |: (field "authors" <| Json.list Json.string)
    |: (field "license" Json.string)
    |: (field "tags" <| Json.list Json.string)
    |: (field "versions" version)
    |: (field "screenshots" screenshots)
    |: (field "stats" stats)

packagesDecoder : Json.Decoder (List Package)
packagesDecoder =
  Json.at ["data", "list"] <| Json.list packageDecoder

singlePackageDecoder : Json.Decoder Package
singlePackageDecoder =
  Json.at ["data"] packageDecoder


-- Networking models
-----------------------------------------------------------------------------------
apiResultDecoder : Json.Decoder ApiResult
apiResultDecoder =
  Json.succeed ApiResult
    |: (field "code" Json.int)
    |: Json.oneOf [field "data" Json.string, Json.succeed ""]
    |: (field "logged_in" Json.bool)
    |: (field "success" Json.bool)
    |: (field "title" Json.string)
    |: (field "version" Json.string)
