module User.View.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)

import Material.Button as Button
import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css)
import Material.Spinner as Loading

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models.User exposing (User)
import Base.Network.Url as Url
import User.Localization as L
import User.Messages as UMsg
import User.Models exposing (UserData)


badge : String -> Html Msg
badge group =
  Chip.button
    [ Options.onClick <| Navigate <| Url.users (Just group) Nothing
    , cs (if group == "admins" then "admin-badge" else "user-badge" )
    ]
    [ Chip.content []
        [ text group ]
    ]

card : UserData -> Int -> User -> Cell Msg
card data index user =
  cell
    [ size All 4 ]
    [ Card.view
        [ Elevation.e2
        , css "z-index" <| toString <| 100-index
        ]
        [ Card.title
            [ cs "card-title user-card-title" ]
            [ Card.head [] [ a [ href <| Url.user user.nickname ] [ text user.nickname ] ] ]
        , Card.actions
            []
            ( List.map badge (if List.isEmpty user.groups then ["user"] else user.groups) )
        , Card.menu [ cs "noselect" ]
            ( if List.member "admins" data.session.user.groups then
                [ Menu.render Mdl [500 + index] data.mdl
                    [ Menu.ripple, Menu.bottomRight ]
                    [ Menu.item
                        [ Menu.onSelect <| Navigate <| Url.editUser user.nickname ]
                        [ Icon.view "mode_edit" [ cs "menu-icon" ], text (L.get data.session.lang L.edit) ]
                    , Menu.item
                        [ Menu.onSelect <| UserMsg <| UMsg.RemoveUser user.nickname ]
                        [ Icon.view "delete" [ cs "menu-icon danger" ], text (L.get data.session.lang L.delete) ]
                    ]
                ]
              else []
            )
        ]
    ]

notFoundCard : UserData -> Html Msg
notFoundCard data =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [] [ Card.head [] [ text (L.get data.session.lang L.nothingFound) ] ]
    , Card.text []
        [ div [] [ text (L.get data.session.lang L.noUsers) ]
        , div [] [ text (L.get data.session.lang L.checkSpelling) ]
        ]
    ]

view : UserData -> Html Msg
view data =
  if data.loading then
    Loading.spinner
      [ Loading.active True
      , cs "spinner"
      ]
  else
    if List.isEmpty data.page.list then div [ class "page" ] [ notFoundCard data ]
    else div []
      [ grid [] <| List.map2 (card data) (List.range 1 <| List.length data.page.list) data.page.list
      , div [ class "more" ]
          [ span []
              [ if data.page.offset > 0 then
                  Button.render Mdl [99] data.mdl
                    [ Button.ripple
                    , Options.onClick <| UserMsg UMsg.PreviousPage
                    ]
                    [ text (L.get data.session.lang L.prevPage) ]
                else
                  div [] []
              , if (data.page.total - data.page.offset) > Config.pageSize then
                  Button.render Mdl [100] data.mdl
                    [ Button.ripple
                    , Options.onClick <| UserMsg UMsg.NextPage
                    ]
                    [ text (L.get data.session.lang L.nextPage) ]
                else
                  div [] []
              ]
          ]
      ]
