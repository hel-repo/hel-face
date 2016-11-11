module Package.Update exposing (..)

import Http
import String exposing (isEmpty)
import Task exposing (Task)

import Base.Config as Config
import Base.Http exposing (..)
import Base.Messages as Outer
import Base.Tools as Tools exposing ((~))
import Package.Encoders exposing (packageEncoder)
import Package.Messages exposing (Msg(..))
import Package.Models exposing (..)
import Package.Decoders exposing (singlePackageDecoder, packagesDecoder)


wrapMsg : Msg -> Cmd Msg
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())

lookupPackage : String -> Cmd Msg
lookupPackage name =
  Http.get singlePackageDecoder (Config.apiHost ++ "packages/" ++ name)
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

savePackage : Package -> Cmd Msg
savePackage package =
  let
    name = if isEmpty package.oldName then package.name else package.oldName
  in
    patch'
      ( Config.apiHost ++ "packages/" ++ name )
      ( packageEncoder package )
      |> Task.mapError toString
      |> Task.perform ErrorOccurred PackageSaved


update : Msg -> PackageData -> ( PackageData, Cmd Msg, List Outer.Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none, [] )
    ErrorOccurred message ->
      { data
        | loading = False
        , packages = []
      } ! [] ~ [ Outer.ErrorOccurred message ]

    -- Network
    FetchPackages searchData ->
      { data | loading = True } ! [ lookupPackages searchData ] ~ []
    PackagesFetched packages ->
      { data
        | packages = packages
        , loading = False
      } ! [] ~ []

    FetchPackage name ->
      { data | loading = True } ! [ lookupPackage name ] ~ []
    PackageFetched package ->
      { data
        | package = package
        , version = 0
        , loading = False
      } ! [] ~ []

    SavePackage package ->
      data ! [ savePackage package ] ~ []
    PackageSaved response ->
      data ! [] ~ [ Outer.SomethingOccurred "Package was succesfully saved!" ]

    -- Navigation
    GoToPackageList searchData ->
      data ! [ wrapMsg (FetchPackages searchData) ] ~ []
    GoToPackageDetails name ->
      data ! [ wrapMsg (FetchPackage name) ] ~ []
    GoToPackageEdit name ->
      if not <| isEmpty name then
        data ! [ wrapMsg (FetchPackage name) ] ~ []
      else
        { data | package = emptyPackage } ! [] ~ []

    GoToVersion num ->
      { data | version = num } ! [] ~ []

    -- Input
    InputName name ->
      let package = data.package
      in { data | package = { package | name = name } } ! [] ~ []

    -- Other
    SharePackage name ->
      { data | share = (if name /= data.share then name else "") } ! [] ~ []
