module Package.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import List exposing (map2, length, isEmpty, member)

import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models exposing (Package)
import Base.Url as Url
import Package.Details exposing (notFoundCard)
import Package.Models exposing (PackageData)
import Package.Messages as PMsg


card : PackageData -> Int -> Package -> Cell Msg
card data index package =
  cell
    [ size All 4 ]
    [ Card.view
        [ Elevation.e2 ]
        [ Card.title
          [ cs "card-title" ]
          [ Card.head [] [ a [ href <| Url.package package.name ] [ text package.name ] ] ]
        , Card.menu
            [ cs "noselect list-card-menu-button" ]
            ( if (member data.session.user.nickname package.owners)
              || (member "admins" data.session.user.groups) then
                [ Menu.render Mdl [index*3] data.mdl
                    [ Menu.ripple, Menu.bottomRight ]
                    [ Menu.item
                        [ Menu.onSelect <| RoutePackageEdit package.name ]
                        [ Icon.view "mode_edit" [ cs "menu-icon" ], text "Edit" ]
                    , Menu.item
                        [ Menu.onSelect <| PackageMsg (PMsg.RemovePackage package.name) ]
                        [ Icon.view "delete" [ cs "menu-icon danger" ], text "Delete" ]
                    ]
                ]
              else []
            )
        , Card.text
            []
            ( if package.name /= data.share then
                [ text package.shortDescription ]
              else
                [ div [ ] [ text "Direct link:" ]
                , div [ class "code" ] [ text <| "hel.fomalhaut.me/" ++ (Url.package package.name) ]
                , div [ ] [ text "Install via HPM:" ]
                , div [ class "code" ] [ text <| "hpm install " ++ package.name ]
                ]
            )
        , Card.actions
            [ Card.border, cs "card-actions" ]
            [ Button.render Mdl [10, index*3+1] data.mdl
                [ Button.icon
                , Button.ripple
                , Button.onClick <| SomethingOccurred "Thank you! :3"
                , cs "noselect"
                ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [10, index*3+2] data.mdl
                [ Button.icon
                , Button.ripple
                , Button.onClick <| PackageMsg (PMsg.SharePackage package.name)
                , cs "noselect"
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
      if isEmpty data.packages.list then div [ class "page" ] [ notFoundCard ]
      else
        div []
          [ grid [] <| map2 (card data) (List.range 1 <| length data.packages.list) data.packages.list
          , div [ class "more" ]
              [ span []
                  [ if data.packages.offset > 0 then
                      Button.render Mdl [99] data.mdl
                        [ Button.ripple
                        , Button.onClick <| PackageMsg PMsg.PreviousPage
                        ]
                        [ text "< Prev Page"]
                    else
                      div [] []
                  , if (data.packages.total - data.packages.offset) > Config.pageSize then
                      Button.render Mdl [100] data.mdl
                        [ Button.ripple
                        , Button.onClick <| PackageMsg PMsg.NextPage
                        ]
                        [ text "Next Page >"]
                    else
                      div [] []
                  ]
              ]
          ]

