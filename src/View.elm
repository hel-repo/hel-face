module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)

import List exposing (length, map)

import Material
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Spinner as Loading
import Material.Options as Options exposing (cs, css)

import Messages exposing (..)
import Models exposing (..)


type alias Mdl =
  Material.Model


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader
    , Layout.onSelectTab SelectTab
    , Layout.selectedTab model.selectedTab
    , Layout.waterfall True
    ]
    { header = [ div [ class "header" ] [ h1 [] [ text "HEL Repository" ] ] ]
    , drawer = []
    , tabs = ( [ text "New", text "Popular", text "All" ], [] )
    , main = [ viewBody model ]
    }


white : Options.Property c m
white =
  Color.text Color.white

viewPackage : Package -> Cell Msg
viewPackage package =
  cell
    [ size All 4
    ]
    [ Card.view
        [ Elevation.e2
        ]
        [ Card.title [ ] [ Card.head [ white ] [ text package.name ] ]
        , Card.text [ white ] [ text package.short_description ]
        , Card.actions
            [ Card.border, cs "card-actions", white ]
            [ Button.render Mdl [8,1] model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [0,0] model.mdl
                [ Button.icon, Button.ripple, white ]
                [ Icon.i "share" ]
            ]
        ]
    ]


viewBody : Model -> Html Msg
viewBody model =
  if model.loading then
    Loading.spinner
      [ Loading.active True
      , cs "spinner"
      ]
  else case model.selectedTab of
    0 ->
      div [] [ grid [] ( map viewPackage model.packages ) ]
    1 ->
      text "Popular"
    2 ->
      text "All"
    _ ->
      text "404"