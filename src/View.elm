module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import String exposing (contains)

import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Layout as Layout
import Material.Options as Options exposing (cs)

import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Package.List
import Package.Details
import Routing exposing (Route(..))


white : Options.Property c m
white =
  Color.text Color.white


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader
    , Layout.waterfall True
    ]
    { header =
      [ div
        [ class "header"
        , onClick (RoutePackageList)
        ]
        [ h1 [] [ text "HEL Repository" ]
        , div
          [ class "error" ]
          ( if contains "404" model.packageData.error then [] else [ text model.packageData.error ] )
        ]
      ]
    , drawer = []
    , tabs = ( [], [] )
    , main = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
  case model.route of
    PackageListRoute ->
      Package.List.view model.packageData

    PackageRoute name ->
      Package.Details.view model.packageData

    NotFoundRoute ->
      div
        [ class "page" ]
        [ Card.view
          [ Elevation.e2 ]
          [ Card.title [ ] [ Card.head [ white ] [ text "404: Page does not exists!" ] ]
          , Card.text [ white ] [ text "Check the spelling, or try different address, please." ]
          ]
        ]