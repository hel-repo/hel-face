module User.View.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)

import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css)
import Material.Spinner as Loading

import Base.Messages exposing (Msg(..))
import Base.Models.User exposing (User)
import Base.Network.Url as Url
import User.Messages as UMsg
import User.Models exposing (UserData)


badge : String -> Html Msg
badge group =
  Chip.button
    [ Options.onClick <| Navigate <| Url.usersByGroup group
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
                        [ Icon.view "mode_edit" [ cs "menu-icon" ], text "Edit" ]
                    , Menu.item
                        [ Menu.onSelect <| UserMsg <| UMsg.RemoveUser user.nickname ]
                        [ Icon.view "delete" [ cs "menu-icon danger" ], text "Delete" ]
                    ]
                ]
              else []
            )
        ]
    ]

notFoundCard : Html Msg
notFoundCard =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [] [ Card.head [] [ text "Nothing found!" ] ]
    , Card.text []
        [ div [] [ text "No users was found by this query." ]
        , div [] [ text "Check the spelling, or try different request, please." ]
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
    if List.isEmpty data.users then div [ class "page" ] [ notFoundCard ]
    else grid [] <| List.map2 (card data) (List.range 1 <| List.length data.users) data.users
