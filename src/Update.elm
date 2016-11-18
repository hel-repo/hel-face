module Update exposing (..)

import Navigation
import Material

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Base.Search exposing (SearchData, searchData, searchQuery)
import Base.Tools exposing (wrapMsg, batchMsg)
import Base.Url as Url
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

    Tick time ->
      if model.notification.delay > 0 then
        let
          notification = model.notification
        in
          { model
            | notification = { notification | delay = max 0 (notification.delay - Config.tickDelay) }
          } ! []
      else
        model ! []

    -- Routing
    Navigate url ->
      model ! [ Navigation.newUrl url ]

    RoutePackageList searchData ->
      let
        packageData = model.packageData
        query = searchQuery searchData
      in
        { model
          | packageData = { packageData | share = "" }
          , search = query
        }
        ! [ Navigation.newUrl <| Url.search query ]

    RoutePackageDetails name ->
      ( model, Navigation.newUrl <| Url.package name )

    RoutePackageEdit name ->
      ( model, Navigation.newUrl <| Url.edit name )

    RouteAuth ->
      ( model, Navigation.newUrl Url.auth )

    RouteRegister ->
      ( model, Navigation.newUrl Url.register )

    RouteProfile ->
      ( model, Navigation.newUrl Url.profile )

    -- Notifications handling
    ErrorOccurred str ->
      { model | notification = error str } ! []

    SomethingOccurred str ->
      { model | notification = info str } ! []

    DismissNotification ->
      { model | notification = emptyNotification } ! []

    -- Other
    InputSearch str ->
      { model | search = str } ! []

    InputKey key ->
      model ! (
        if key == Config.enterKey then [ wrapMsg <| RoutePackageList <| searchData model.search ]
        else []
      )

    -- Hook module messages up
    PackageMsg subMsg ->
      let
        ( updatedData, cmd, transferred ) =
          Package.Update.update subMsg model.packageData
      in
        { model | packageData = updatedData } ! [ Cmd.map PackageMsg cmd, batchMsg transferred ]

    UserMsg subMsg ->
      let
        ( updatedData, cmd, transferred ) =
          User.Update.update subMsg model.userData
        packageData = model.packageData
      in
        { model | userData = updatedData, packageData = { packageData | username = updatedData.user.nickname } }
        ! [ Cmd.map UserMsg cmd, batchMsg transferred ]