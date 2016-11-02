module Update exposing (..)

import String exposing (isEmpty)

import Navigation
import Material

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Base.Tools exposing (wrapMsg)
import Package.Models exposing (searchByName)
import Package.Update
import User.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    -- Transfer MDL events
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

    RouteRegister ->
      ( model, Navigation.newUrl "#register" )

    RouteProfile ->
      ( model, Navigation.newUrl "#profile" )

    -- Other
    InputSearch str ->
      { model | search = str } ! []

    InputKey key ->
      model ! (
        if key == Config.enterKey then [ wrapMsg <| RoutePackageList <| searchByName model.search ]
        else []
      )

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