module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, href)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, (:=))
import String exposing (contains, isEmpty)

import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs)
import Material.Textfield as Textfield

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Package.List
import Package.Details
import Package.Models exposing (searchAll, searchByName)
import Routing exposing (Route(..))
import User.Auth
import User.Profile
import User.Register


search : Msg
search =
  InputKey Config.enterKey

keyDecoder : Decode.Decoder Msg
keyDecoder =
  Decode.map InputKey
    <| Decode.object1 identity
        (Decode.at ["keyCode"] Decode.int)


white : Options.Property c m
white =
  Color.text Color.white


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader ]
    { header =
      [ div
          [ class "header" ]
          [ div [ class "header-title noselect", onClick <| RoutePackageList searchAll ] [ text "HEL Repository" ]
          , div [ class "search" ]
              [ Textfield.render Mdl [0] model.mdl
                  [ Textfield.style
                      [ Options.attribute <| attribute "spellcheck" "false"
                      , Options.attribute <| attribute "autocomplete" "off"
                      , Options.attribute <| attribute "autocorrect" "off"
                      , Options.attribute <| attribute "autocapitalize" "off"
                      ]
                  , Textfield.onInput InputSearch
                  , Textfield.on "keyup" keyDecoder
                  ]
              , Button.render Mdl [1] model.mdl
                  [ Button.icon
                  , Button.ripple
                  , cs "search-icon noselect"
                  , Button.onClick search
                  ]
                  [ Icon.i "search"]
              ]
          , if model.userData.loggedin then
              div [ class "login-button noselect" ]
                  [ Button.render Mdl [2] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Button.onClick RouteProfile
                      ]
                      [ Icon.view "account_circle" [ Icon.size48 ] ]
                  ]
            else
              div [ class "login-button noselect" ]
                  [ Button.render Mdl [2] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Button.onClick RouteAuth
                      ]
                      [ Icon.view "fingerprint" [ Icon.size48 ] ]
                  ]
          ]
      ]
    , drawer = []
    , tabs = ( [], [] )
    , main = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
  div [ ]
    [ div
        [ class "error"
        , onClick DismissNotification
        ]
        ( if isEmpty model.error || contains "404" model.error then []
          else
            [ Icon.view "error_outline" [ cs "align-middle" ]
            , span [ class "align-middle notification-text" ] [ text model.error ]
            ]
        )
    , div
        [ class "notify"
        , onClick DismissNotification
        ]
        ( if isEmpty model.notification then []
          else
            [ Icon.view "info_outline" [ cs "align-middle" ]
            , span [ class "align-middle notification-text" ] [ text model.notification ]
            ]
        )
    , case model.route of
        PackageListRoute searchData ->
          Package.List.view model.packageData

        PackageRoute name ->
          Package.Details.view model.packageData

        AuthRoute ->
          User.Auth.view model.userData

        RegisterRoute ->
          User.Register.view model.userData

        ProfileRoute ->
          User.Profile.view model.userData

        NotFoundRoute ->
          div
            [ class "page" ]
            [ Card.view
              [ Elevation.e2 ]
              [ Card.title [ ] [ Card.head [ white ] [ text "404: Page does not exist!" ] ]
              , Card.text [ white ] [ text "Check the address for typing errors." ]
              ]
            ]
    ]
