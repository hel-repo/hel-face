module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, href)
import Html.Events exposing (onClick)
import String exposing (contains)

import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs)
import Material.Textfield as Textfield

import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Package.List
import Package.Details
import Package.Models exposing (searchAll, searchByName)
import Routing exposing (Route(..))
import User.Auth
import User.Register


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
          [ div [ class "header-title", onClick <| RoutePackageList searchAll ] [ text "HEL Repository" ]
          , div [ class "search" ]
              [ Textfield.render Mdl [0] model.mdl
                  [ Textfield.style
                      [ Options.attribute <| attribute "spellcheck" "false"
                      , Options.attribute <| attribute "autocomplete" "off"
                      , Options.attribute <| attribute "autocorrect" "off"
                      , Options.attribute <| attribute "autocapitalize" "off"
                      ]
                  , Textfield.onInput (searchByName >> RoutePackageList)
                  ]
              , Button.render Mdl [1] model.mdl
                  [ Button.icon
                  , Button.ripple
                  , cs "search-icon"
                  ]
                  [ Icon.i "search"]
              ]
          , div [ class "login-button" ]
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
        [ class "error" ]
        ( if contains "404" model.packageData.error then [] else [ text model.packageData.error ] )
    , case model.route of
        PackageListRoute searchData ->
          Package.List.view model.packageData

        PackageRoute name ->
          Package.Details.view model.packageData

        AuthRoute ->
          User.Auth.view model.userData

        RegisterRoute ->
          User.Register.view model.userData

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
