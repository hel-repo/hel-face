module Package.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events
import List exposing (map)

import Material.Button as Button
import Material.Color as Color
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading

import Base.Messages exposing (Msg(..))
import Base.Models exposing (materialModel)
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
        , Options.attribute <| Html.Events.onClick (RoutePackageDetails package.name)
        ]
        [ Card.title
          [ cs "card-title" ]
          [ Card.head [ white ] [ a [ href ("#packages/" ++ package.name) ] [ text package.name ] ] ]
        , Card.text [ white ] [ text package.short_description ]
        , Card.actions
            [ Card.border, cs "card-actions", white ]
            [ Button.render Mdl [8,1] materialModel
                [ Button.icon, Button.ripple ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [0,0] materialModel
                [ Button.icon, Button.ripple, white ]
                [ Icon.i "share" ]
            ]
        ]
    ]


view : PackageListData -> Html Msg
view data =
    if data.loading then
      Loading.spinner
        [ Loading.active True
        , cs "spinner"
        ]
    else
      div [] [ grid [] ( map card data.packages ) ]