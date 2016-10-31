module Update exposing (..)

import String exposing (isEmpty)

import Navigation
import Material

import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Package.Update
import User.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Mdl msg' ->
      -- TODO: make it prettier
      let
        (uModel, uCmd) = Material.update msg' model
      in let
          packageData = uModel.packageData
          userData = uModel.userData
        in
          { uModel
          | packageData = { packageData | mdl = uModel.mdl }
          , userData = { userData | mdl = uModel.mdl }
          } ! [ uCmd ]

    -- Routing
    RoutePackageList searchData ->
      let packageData = model.packageData
      in
        ( { model | packageData = { packageData | share = "" } }
        , Navigation.newUrl <|
            if isEmpty searchData.name
              then "#packages/"
              else "#search/" ++ searchData.name
        )

    RoutePackageDetails name ->
      ( model, Navigation.newUrl ("#packages/" ++ name) )

    RouteAuth ->
      ( model, Navigation.newUrl "#auth" )

    -- Hook module messages up
    PackageMsg subMsg ->
      let
        ( updatedData, cmd ) =
          Package.Update.update subMsg model.packageData
      in
        ( { model | packageData = updatedData }, Cmd.map PackageMsg cmd )
    UserMsg subMsg ->
      let
        ( updatedData, cmd ) =
          User.Update.update subMsg model.userData
      in
        ( { model | userData = updatedData }, Cmd.map UserMsg cmd )