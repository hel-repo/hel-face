module Package.View.List exposing (..)

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
import Base.Models.Package exposing (Package)
import Base.Network.Url as Url
import Package.Localization as L
import Package.Models exposing (PackageData)
import Package.Messages as PMsg
import Package.View.Details exposing (notFoundCard)


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
                        [ Icon.view "mode_edit" [ cs "menu-icon" ], text (L.get data.session.lang L.edit) ]
                    , Menu.item
                        [ Menu.onSelect <| PackageMsg (PMsg.RemovePackage package.name) ]
                        [ Icon.view "delete" [ cs "menu-icon danger" ], text (L.get data.session.lang L.delete) ]
                    ]
                ]
              else []
            )
        , Card.text
            []
            ( if package.name /= data.share then
                [ text package.shortDescription ]
              else
                [ div [ ] [ text (L.get data.session.lang L.directLink) ]
                , div [ class "code" ] [ text <| "hel.fomalhaut.me/" ++ (Url.package package.name) ]
                , div [ ] [ text (L.get data.session.lang L.installViaHpm) ]
                , div [ class "code" ] [ text <| "hpm install " ++ package.name ]
                ]
            )
        , Card.actions
            [ Card.border, cs "card-actions" ]
            [ Button.render Mdl [10, index*3+1] data.mdl
                [ Button.icon
                , Button.ripple
                , Options.onClick <| SomethingOccurred (L.get data.session.lang L.thanks)
                , cs "noselect"
                ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [10, index*3+2] data.mdl
                [ Button.icon
                , Button.ripple
                , Options.onClick <| PackageMsg (PMsg.SharePackage package.name)
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
      if isEmpty data.page.list then div [ class "page" ] [ notFoundCard data ]
      else
        div []
          [ grid [] <| map2 (card data) (List.range 1 <| length data.page.list) data.page.list
          , div [ class "more" ]
              [ span []
                  [ if data.page.offset > 0 then
                      Button.render Mdl [99] data.mdl
                        [ Button.ripple
                        , Options.onClick <| PackageMsg PMsg.PreviousPage
                        ]
                        [ text (L.get data.session.lang L.prevPage) ]
                    else
                      div [] []
                  , if (data.page.total - data.page.offset) > Config.pageSize then
                      Button.render Mdl [100] data.mdl
                        [ Button.ripple
                        , Options.onClick <| PackageMsg PMsg.NextPage
                        ]
                        [ text (L.get data.session.lang L.nextPage) ]
                    else
                      div [] []
                  ]
              ]
          ]
