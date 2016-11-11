module Package.Decoders exposing (..)

import Json.Decode as Json exposing ((:=))
import Json.Decode.Extra exposing ((|:))

import Package.Models exposing (..)


pkgScreenshotList : List (String, String) -> Json.Decoder (List Screenshot)
pkgScreenshotList list =
  Json.succeed (List.map (\(url, desc) -> Screenshot url desc) list)

screenshots : Json.Decoder (List Screenshot)
screenshots =
  Json.keyValuePairs Json.string `Json.andThen` pkgScreenshotList

pkgVersionFileData : Json.Decoder PkgVersionFileData
pkgVersionFileData =
  Json.succeed PkgVersionFileData
    |: ("dir" := Json.string)
    |: ("name" := Json.string)

pkgVersionFilesList : List (String, PkgVersionFileData) -> Json.Decoder (List PkgVersionFile)
pkgVersionFilesList list =
  Json.succeed (List.map (\(url, data) -> PkgVersionFile url data.dir data.name) list)

pkgVersionFiles : Json.Decoder (List PkgVersionFile)
pkgVersionFiles =
  Json.keyValuePairs pkgVersionFileData `Json.andThen` pkgVersionFilesList

pkgVersionDependencyData : Json.Decoder PkgVersionDependencyData
pkgVersionDependencyData =
  Json.succeed PkgVersionDependencyData
    |: ("type" := Json.string)
    |: ("version" := Json.string)

pkgVersionDependencyList : List (String, PkgVersionDependencyData) -> Json.Decoder (List PkgVersionDependency)
pkgVersionDependencyList list =
  Json.succeed (List.map (\(name, data) -> PkgVersionDependency name data.deptype data.version) list)

pkgVersionDependencies : Json.Decoder (List PkgVersionDependency)
pkgVersionDependencies =
  Json.keyValuePairs pkgVersionDependencyData `Json.andThen` pkgVersionDependencyList

pkgVersionData : Json.Decoder PkgVersionData
pkgVersionData =
  Json.succeed PkgVersionData
    |: ("files" := pkgVersionFiles)
    |: ("depends" := pkgVersionDependencies)
    |: ("changes" := Json.string)

pkgVersionList : List (String, PkgVersionData) -> Json.Decoder (List Version)
pkgVersionList list =
  Json.succeed (List.map (\(version, data) -> Version version data.files data.depends data.changes) list)

version : Json.Decoder (List Version)
version =
  Json.keyValuePairs pkgVersionData `Json.andThen` pkgVersionList

pkgStatsDate : Json.Decoder PkgStatsDate
pkgStatsDate =
  Json.succeed PkgStatsDate
    |: ("created" := Json.string)
    |: ("last-updated" := Json.string)

stats : Json.Decoder Stats
stats =
  Json.succeed Stats
    |: ("views" := Json.int)
    |: ("date" := pkgStatsDate)

packageDecoder : Json.Decoder Package
packageDecoder =
  Json.succeed Package
    |: ("name" := Json.string)
    |: ("name" := Json.string)  -- fill oldName field with the same data
    |: ("description" := Json.string)
    |: ("short_description" := Json.string)
    |: ("owners" := Json.list Json.string)
    |: ("authors" := Json.list Json.string)
    |: ("license" := Json.string)
    |: ("tags" := Json.list Json.string)
    |: ("versions" := version)
    |: ("screenshots" := screenshots)
    |: ("stats" := stats)

packagesDecoder : Json.Decoder (List Package)
packagesDecoder =
  Json.at ["data", "list"] ( Json.list packageDecoder )

singlePackageDecoder : Json.Decoder Package
singlePackageDecoder =
  Json.at ["data"] packageDecoder