module Update exposing (..)

import Navigation
import Material

import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Package.Messages as PMsg
import Package.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Mdl msg' ->
      Material.update msg' model

    -- Routing
    RoutePackageList ->
      ( model, Navigation.newUrl "#packages/" )

    RoutePackageDetails name ->
      ( model, Navigation.newUrl ("#packages/" ++ name) )

    -- Hook package messages up
    PackageMsg subMsg ->
      let
        ( updatedList, cmd ) =
          Package.Update.update subMsg model.list
      in
        ( { model | list = updatedList }, Cmd.map PackageMsg cmd )