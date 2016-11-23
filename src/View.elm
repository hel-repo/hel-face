module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, href, src)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import String exposing (contains, isEmpty)

import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs)
import Material.Textfield as Textfield

import About
import Models exposing (..)
import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Search exposing (searchAll, searchByName)
import Package.List
import Package.Details
import Package.Edit
import Routing exposing (Route(..))
import User.Auth
import User.Messages as UMsg
import User.Profile
import User.Register
import User.List
import User.Edit


keyDecoder : Decode.Decoder Msg
keyDecoder =
  Decode.map InputKey
    <| Decode.map identity
        (Decode.at ["keyCode"] Decode.int)


notification : Notification -> Html Msg
notification data =
  div
    [ class
        ( case data.ntype of
            Error -> "error"
            _ -> "info"
        )
    , onClick DismissNotification
    ]
    ( if (isEmpty data.message) || (data.delay <= 0) then []
      else
        [ Icon.view
            ( case data.ntype of
                Error -> "error_outline"
                _ -> "info_outline"
            )
            [ cs "align-middle" ]
        , span [ class "align-middle notification-text" ] [ text data.message ]
        ]
    )


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader ]
    { header =
      [ div
          [ class "header" ]
          [ div
              [ class "header-title noselect", onClick <| RoutePackageList searchAll ]
              [ img [ src "static/media/logo.7c5853e0.png", class "header-image" ] [] ]
          , div [ class "search" ]
              [ Textfield.render Mdl [0] model.mdl
                  [ Textfield.style
                      [ Options.attribute <| attribute "spellcheck" "false"
                      , Options.attribute <| attribute "autocomplete" "off"
                      , Options.attribute <| attribute "autocorrect" "off"
                      , Options.attribute <| attribute "autocapitalize" "off"
                      ]
                  , Textfield.value model.search
                  , Textfield.onInput InputSearch
                  , Textfield.on "keyup" keyDecoder
                  ]
              , Button.render Mdl [1] model.mdl
                  [ Button.icon
                  , Button.ripple
                  , cs "search-icon noselect"
                  , Button.onClick <| InputKey Config.enterKey
                  ]
                  [ Icon.i "search"]
              ]
          , if model.session.loggedin then
              div [ class "buttons noselect" ]
                  [ Button.render Mdl [5] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Button.onClick <| RoutePackageEdit ""
                      ]
                      [ Icon.view "add_circle_outline" [ Icon.size36 ] ]
                  , Button.render Mdl [4] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Button.onClick RouteProfile
                      ]
                      [ Icon.view "account_circle" [ Icon.size36 ] ]
                  , Button.render Mdl [3] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Button.onClick RouteAbout
                      ]
                      [ Icon.view "help_outline" [ Icon.size36 ] ]
                  , Button.render Mdl [2] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Button.onClick <| UserMsg UMsg.LogOut
                      ]
                      [ Icon.view "exit_to_app" [ Icon.size36 ] ]
                  ]
            else
              div [ class "buttons noselect" ]
                  [ Button.render Mdl [3] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Button.onClick RouteAuth
                      ]
                      [ Icon.view "fingerprint" [ Icon.size36 ] ]
                  , Button.render Mdl [2] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Button.onClick RouteAbout
                      ]
                      [ Icon.view "help_outline" [ Icon.size36 ] ]
                  ]
          ]
      , notification model.notification
      ]
    , drawer = []
    , tabs = ( [], [] )
    , main = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
  case model.route of
    PackageListRoute searchData ->
      Package.List.view model.packageData

    PackageRoute name ->
      Package.Details.view model.packageData

    PackageEditRoute name ->
      Package.Edit.view model.packageData

    AuthRoute ->
      User.Auth.view model.userData

    RegisterRoute ->
      User.Register.view model.userData

    ProfileRoute nickname ->
      User.Profile.view model.userData

    UserListRoute ->
      User.List.view model.userData

    UserEditRoute nickname ->
      User.Edit.view model.userData

    AboutRoute ->
      About.view model.session

    NotFoundRoute ->
      div
        [ class "page" ]
        [ Card.view
          [ Elevation.e2 ]
          [ Card.title [] [ Card.head [] [ text "404: Page does not exist!" ] ]
          , Card.text [] [ text "Check the address for typing errors." ]
          ]
        ]
