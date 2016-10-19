module Package.List exposing (..)

import Html exposing (..)
import List exposing (map)

import Material.Button as Button
import Material.Color as Color
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Options as Options exposing (cs, css)
import Material.Spinner as Loading

import Messages exposing (Msg(..))
import Models exposing (Model, initialModel)
import Package.Models exposing (PackageListData, Package)


white : Options.Property c m
white =
  Color.text Color.white


card : Package -> Cell Msg
card package =
  cell
    [ size All 4
    ]
    [ Card.view
        [ Elevation.e2
        ]
        [ Card.title [] [ Card.head [ white ] [ text package.name ] ]
        , Card.text [ white ] [ text package.short_description ]
        , Card.actions
            [ Card.border, cs "card-actions", white ]
            [ Button.render Mdl [8,1] initialModel.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [0,0] initialModel.mdl
                [ Button.icon, Button.ripple, white ]
                [ Icon.i "share" ]
            ]
        ]
    ]


list : PackageListData -> Html Msg
list data =
    if data.loading then
      Loading.spinner
        [ Loading.active True
        , cs "spinner"
        ]
    else
      div [] [ grid [] ( map card data.packages ) ]