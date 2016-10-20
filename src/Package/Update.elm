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
    |: ("created" := Json.Decode.Extra.date)
    |: ("last-updated" := Json.Decode.Extra.date)

stats : Json.Decoder Stats
stats =
  Json.succeed Stats
    |: ("views" := Json.int)
    |: ("downloads" := Json.int)
    |: ("date" := pkgStatsDate)

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
      |: ("versions" := version)
      |: ("screenshots" := screenshots)
      |: ("stats" := stats)
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
