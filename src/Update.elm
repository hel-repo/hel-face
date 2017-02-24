module Update exposing (..)

import Navigation
import UrlParser as Url

import Material
import Material.Helpers exposing (map1st, map2nd)
import Material.Snackbar as Snackbar

import Base.Config as Config
import Base.Helpers.Search exposing (PackagePage, packageQueryToPhrase, phraseToPackageQuery)
import Base.Helpers.Tools exposing (wrapMsg, batchMsg)
import Base.Messages exposing (Msg(..))
import Base.Models.Generic exposing (SnackbarType(..))
import Base.Models.Network exposing (firstPage)
import Base.Models.User exposing (Session)
import Base.Network.Api as Api
import Base.Network.Url as Url
import Localization as L
import Models exposing (..)
import Package.Update
import User.Update

import Routing exposing (Route(..))


updateSession : Model -> Session -> Model
updateSession model session =
  let
    packageData = model.packageData
    userData = model.userData
  in
    { model
      | session = session
      , packageData = { packageData | session = session }
      , userData = { userData | session = session }
    }

notify : SnackbarType -> String -> Model -> (Model, Cmd Msg)
notify stype message model =
  let
    (snackbar_, eff) =
      Snackbar.add (Snackbar.toast stype message) model.snackbar
        |> map2nd (Cmd.map Snackbar)
  in
    ({ model | snackbar = snackbar_ }, eff)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    -- Transfer MDL events
    Mdl mmsg ->
      let
        (uModel, uCmd) = Material.update Mdl mmsg model
      in let
          packageData = uModel.packageData
          userData = uModel.userData
        in
          { uModel
          | packageData = { packageData | mdl = uModel.mdl }
          , userData = { userData | mdl = uModel.mdl }
          } ! [ uCmd ]

    -- Transfer snackbar events
    Snackbar (Snackbar.Begin t) ->
      { model | snackbarType = t } ! []

    Snackbar msg_ ->
      Snackbar.update msg_ model.snackbar
        |> map1st (\s -> { model | snackbar = s })
        |> map2nd (Cmd.map Snackbar)

    -- Handle local storage actions
    StorageLoaded code ->
      let
        old = model.session
        session = { old | lang = code }
      in
        ( updateSession model session ) ! []

    -- Network
    ChangeSession session ->
      ( updateSession model session ) ! []

    CheckSession ->
      model ! [ Api.checkSession SessionChecked ]

    SessionChecked (Ok session) ->
      let
        cmd1 = wrapMsg <| ChangeSession { session | lang = model.session.lang } -- don't allow to rewrite lang variable
        cmd2 = if String.isEmpty session.user.nickname then [ cmd1 ]
               else [ cmd1, Api.fetchUser session.user.nickname UserFetched ]
        cmd3 = case model.route of
                 PackageEditRoute _ ->
                   if session.loggedin then cmd2
                   else (wrapMsg <| Navigate Url.home) :: cmd2  -- user cannot edit anything, while not logged in
                 _ -> cmd2
      in model ! cmd3

    SessionChecked (Err _) ->
      let
        cmd1 = wrapMsg <| ErrorOccurred (L.get model.session.lang L.failedToGetSession)
        cmd2 = case model.route of
                 PackageEditRoute _ ->
                   if model.session.loggedin then [ cmd1 ]
                   else [ wrapMsg <| Navigate Url.home, cmd1 ]
                 _ -> [ cmd1 ]
      in model ! cmd2

    UserFetched (Ok user) ->
      let session = model.session
      in model ! [ wrapMsg <| ChangeSession { session | user = user } ]
    UserFetched (Err _) ->
      model ! [ wrapMsg <| ErrorOccurred (L.get model.session.lang L.failedToGetProfile) ]

    -- Routing
    UpdateUrl location ->
      let currentRoute = Maybe.withDefault NotFoundRoute <| Url.parseHash Routing.route location
      in ( { model | route = currentRoute }, batchMsg ( Routing.routeMessage currentRoute ) )

    SearchBox phrase ->
      { model | search = phrase } ! []

    Navigate url ->
      model ! [ Navigation.newUrl url ]

    Back ->
      model ! [ Navigation.back 1 ]

    RoutePackageList page ->
      let
        packageData = model.packageData
        phrase = packageQueryToPhrase page.query
      in
        { model | packageData = { packageData | share = "", page = page } }
        ! [ Navigation.newUrl <| Url.packages (Just phrase) (Just (page.offset // Config.pageSize)) ]

    RoutePackageDetails name ->
      ( model, Navigation.newUrl <| Url.package name )

    RoutePackageEdit name ->
      case model.session.loggedin of
        True -> ( model, Navigation.newUrl <| Url.edit name )
        False -> ( model, Navigation.newUrl Url.home )

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
      notify Error str model

    SomethingOccurred str ->
      notify Info str model

    -- Input
    InputSearch str ->
      { model | search = str } ! []

    InputKey key ->
      model ! (
        if key == Config.enterKey then
          [ wrapMsg <| RoutePackageList <| firstPage <| phraseToPackageQuery model.search ]
        else
          [ ]
      )

    -- Hook module messages up
    PackageMsg subMsg ->
      let
        ( updatedData, cmd, transferred ) =
          Package.Update.update subMsg model.packageData
      in
        { model | packageData = updatedData }
        ! [ Cmd.map PackageMsg cmd, batchMsg transferred ]

    UserMsg subMsg ->
      let
        ( updatedData, cmd, transferred ) =
          User.Update.update subMsg model.userData
      in
        { model | userData = updatedData }
        ! [ Cmd.map UserMsg cmd, batchMsg transferred ]
