module Update exposing (..)

import Material
import Navigation
import UrlParser as Url

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Base.Search exposing (SearchData, searchData, searchQuery)
import Base.Tools exposing (wrapMsg, batchMsg)
import Base.Url as Url
import Package.Update
import User.Update

import Routing exposing (Route(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    -- Transfer MDL events
    Mdl mmsg ->
      -- TODO: make it prettier
      let
        (uModel, uCmd) = Material.update mmsg model
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
    UpdateUrl location ->
      let currentRoute = Maybe.withDefault NotFoundRoute <| Url.parseHash Routing.route location
      in ( { model | route = currentRoute }, batchMsg ( Routing.routeMessage currentRoute ) )

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

    RouteAbout ->
      ( model, Navigation.newUrl Url.about )

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
        { model
          | userData = updatedData
          , packageData = { packageData | username = updatedData.user.nickname, userGroups = updatedData.user.groups }
        } ! [ Cmd.map UserMsg cmd, batchMsg transferred ]
