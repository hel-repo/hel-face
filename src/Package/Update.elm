module Package.Update exposing (..)

import Http
import String exposing (isEmpty)
import Task exposing (Task)

import Base.Config as Config
import Package.Messages exposing (Msg(..))
import Package.Models exposing (..)
import Package.Decoders exposing (packageDecoder, packagesDecoder)


wrapMsg : Msg -> Cmd Msg
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())

lookupPackage : String -> Cmd Msg
lookupPackage name =
  Http.get packageDecoder (Config.apiHost ++ "packages/" ++ name)
    |> Task.mapError toString
    |> Task.perform ErrorOccurred PackageFetched

lookupPackages : SearchData -> Cmd Msg
lookupPackages data =
  Http.get packagesDecoder
    ( Config.apiHost
      ++ "packages"
      ++ (if isEmpty data.name then "" else "?name=" ++ data.name)
    )
    |> Task.mapError toString
    |> Task.perform ErrorOccurred PackagesFetched


update : Msg -> PackageListData -> ( PackageListData, Cmd Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none )
    ErrorOccurred message ->
      { data
        | error = message
        , loading = False
        , packages = []
      } ! []

    -- Network
    FetchPackages searchData ->
      { data | loading = True } ! [lookupPackages searchData]
    PackagesFetched packages ->
      { data
        | packages = packages
        , loading = False
        , error = ""
      } ! []

    FetchPackage name ->
      { data | loading = True } ! [lookupPackage name]
    PackageFetched package ->
      { data
        | packages = [ package ]
        , version = 0
        , loading = False
        , error = ""
      } ! []

    -- Navigation
    GoToPackageList searchData ->
      data ! [ wrapMsg (FetchPackages searchData) ]
    GoToPackageDetails name ->
      data ! [ wrapMsg (FetchPackage name) ]

    GoToVersion num ->
      { data | version = num } ! []

    -- Other
    SharePackage name ->
      { data | share = (if name /= data.share then name else "") } ! []