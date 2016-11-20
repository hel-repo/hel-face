module Package.Decoders exposing (..)

import Json.Decode as Json exposing (field)
import Json.Decode.Extra exposing ((|:))

import Package.Models exposing (..)


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

pkgVersionFilesList : List (String, PkgVersionFileData) -> Json.Decoder (List PkgVersionFile)
pkgVersionFilesList list =
  Json.succeed (List.map (\(url, data) -> PkgVersionFile url data.dir data.name False) list)

pkgVersionFiles : Json.Decoder (List PkgVersionFile)
pkgVersionFiles =
  Json.keyValuePairs pkgVersionFileData |> Json.andThen pkgVersionFilesList

pkgVersionDependencyData : Json.Decoder PkgVersionDependencyData
pkgVersionDependencyData =
  Json.succeed PkgVersionDependencyData
    |: (field "type" Json.string)
    |: (field "version" Json.string)

pkgVersionDependencyList : List (String, PkgVersionDependencyData) -> Json.Decoder (List PkgVersionDependency)
pkgVersionDependencyList list =
  Json.succeed (List.map (\(name, data) -> PkgVersionDependency name data.deptype data.version False) list)

pkgVersionDependencies : Json.Decoder (List PkgVersionDependency)
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