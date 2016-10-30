module Package.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
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
import Package.Messages as PMsg


white : Options.Property c m
white =
  Color.text Color.white


card : String -> Package -> Cell Msg
card share package =
  cell
    [ size All 4
    ]
    [ Card.view
        [ Elevation.e2 ]
        [ Card.title
          [ cs "card-title"
          , Options.attribute <| Html.Events.onClick (RoutePackageDetails package.name)
          ]
          [ Card.head [ white ] [ a [ href ("#packages/" ++ package.name) ] [ text package.name ] ] ]
        , Card.text
            [ white ]
            ( if package.name /= share then
                [ text package.short_description ]
              else
                [ div [ ] [ text "Direct link:" ]
                , div [ class "code" ] [ text <| "hel.fomalhaut.me/#packages/" ++ package.name ]
                , div [ ] [ text "Install via HPM:" ]
                , div [ class "code" ] [ text <| "hpm install " ++ package.name ]
                ]
            )
        , Card.actions
            [ Card.border, cs "card-actions", white ]
            [ Button.render Mdl [8,1] materialModel
                [ Button.icon, Button.ripple ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [0,0] materialModel
                [ Button.icon
                , Button.ripple
                , Button.onClick <| PackageMsg (PMsg.SharePackage package.name)
                , white
                ]
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
      div [] [ grid [] ( map (card data.share) data.packages ) ]