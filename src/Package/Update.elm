module Package.Update exposing (..)

import Http
import List
import Task exposing (Task)
import Json.Decode as Json exposing ((:=))
import Json.Decode.Extra exposing ((|:))

import Package.Messages exposing (Msg(..))
import Package.Models exposing (..)


pkgScreenshotList : List (String, String) -> Json.Decoder (List Screenshot)
pkgScreenshotList list =
  Json.succeed (List.map (\(url, desc) -> Screenshot url desc) list)

pkgScreenshots : Json.Decoder (List Screenshot)
pkgScreenshots =
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

pkgVersionList : List (String, PkgVersionData) -> Json.Decoder (List PkgVersion)
pkgVersionList list =
  Json.succeed (List.map (\(version, data) -> PkgVersion version data.files data.depends data.changes) list)

pkgVersion : Json.Decoder (List PkgVersion)
pkgVersion =
  Json.keyValuePairs pkgVersionData `Json.andThen` pkgVersionList

packagesDecoder : Json.Decoder (List Package)
packagesDecoder =
  let package =
    Json.succeed Package
      |: ("name" := Json.string)
      |: ("description" := Json.string)
      |: ("short_description" := Json.string)
      |: ("owners" := Json.list Json.string)
      |: ("authors" := Json.list Json.string)
      |: ("license" := Json.string)
      |: ("tags" := Json.list Json.string)
      |: ("versions" := pkgVersion)
      |: ("screenshots" := pkgScreenshots)
  in
    Json.at ["data"] ( Json.list package )

lookupPackages : Cmd Msg
lookupPackages =
  Http.get packagesDecoder "http://hel-roottree.rhcloud.com/packages"
    |> Task.mapError toString
    |> Task.perform ErrorOccurred PackagesFetched


update : Msg -> PackageListData -> ( PackageListData, Cmd Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none )

    FetchPackages ->
      { data | loading = True } ! [lookupPackages]

    ErrorOccurred message ->
      { data | error = message, loading = False } ! []

    PackagesFetched packages ->
      { data | packages = packages, loading = False } ! []
