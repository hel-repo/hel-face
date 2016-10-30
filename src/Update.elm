module Update exposing (..)

import Navigation
import Material

import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Package.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Mdl msg' ->
      Material.update msg' model

    -- Routing
    RoutePackageList ->
      let packageData = model.packageData
      in ( { model | packageData = { packageData | share = "" } }, Navigation.newUrl "#packages/" )

    RoutePackageDetails name ->
      ( model, Navigation.newUrl ("#packages/" ++ name) )

    -- Hook package messages up
    PackageMsg subMsg ->
      let
        ( updatedData, cmd ) =
          Package.Update.update subMsg model.packageData
      in
        ( { model | packageData = updatedData }, Cmd.map PackageMsg cmd )