module Package.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events
import List exposing (map2, length, isEmpty)

import Material
import Material.Button as Button
import Material.Color as Color
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading

import Base.Messages exposing (Msg(..))
import Package.Details exposing (notFoundCard)
import Package.Models exposing (PackageData, Package)
import Package.Messages as PMsg


white : Options.Property c m
white =
  Color.text Color.white


card : Material.Model -> String -> Int -> Package -> Cell Msg
card mdl share index package =
  cell
    [ size All 4
    ]
    [ Card.view
        [ Elevation.e2 ]
        [ Card.title
          [ cs "card-title" ]
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
            [ Button.render Mdl [10, index*2] mdl
                [ Button.icon
                , Button.ripple
                , Button.onClick <| SomethingOccurred "Thank you!"
                , cs "noselect"
                ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [10, index*2+1] mdl
                [ Button.icon
                , Button.ripple
                , Button.onClick <| PackageMsg (PMsg.SharePackage package.name)
                , cs "noselect"
                , white
                ]
                [ Icon.i "share" ]
            ]
        ]
    ]


view : PackageData -> Html Msg
view data =
    if data.loading then
      Loading.spinner
        [ Loading.active True
        , cs "spinner"
        ]
    else
      if isEmpty data.packages then div [ class "page" ] [ notFoundCard ]
      else grid [] ( map2 (card data.mdl data.share) [1..(length data.packages)] data.packages )