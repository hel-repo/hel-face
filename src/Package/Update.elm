module Package.Update exposing (..)

import Http
import Task exposing (Task)
import Json.Decode as Json exposing ((:=))

import Package.Messages exposing (Msg(..))
import Package.Models exposing (..)


packagesDecoder : Json.Decoder (List Package)
packagesDecoder =
  let package =
    Json.object6 Package
        ("name" := Json.string)
        ("description" := Json.string)
        ("short_description" := Json.string)
        ("owners" := Json.list Json.string)
        ("authors" := Json.list Json.string)
        ("tags" := Json.list Json.string)
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