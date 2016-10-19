module Update exposing (..)

import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)

import Material

import Messages exposing (Msg(..))
import Models exposing (..)
import Package.Models exposing(Package)
import Package.Update


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Mdl msg' ->
      Material.update msg' model

    PackageMsg subMsg ->
      let
        ( updatedPackages, cmd ) =
          Package.Update.update subMsg model.packages
      in
        ( { model | packages = updatedPackages }, Cmd.map PackageMsg cmd )

    SelectTab num ->
      let
        newModel = { model | selectedTab = num }
      in
        if num == 0 then
          update FetchPackages newModel
        else
          newModel ! []

    FetchPackages ->
      { model | loading = True } ! [lookupPackages]

    ErrorOccurred message ->
      { model | error = message, loading = False } ! []

    PackagesFetched packages ->
      { model | packages = packages, loading = False } ! []