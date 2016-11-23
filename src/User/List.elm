module User.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)

import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Options exposing (cs)
import Material.Spinner as Loading

import Base.Messages exposing (Msg(..))
import Base.Models exposing (User)
import Base.Url as Url
import User.Models exposing (UserData)


badge : String -> Html Msg
badge group =
  Chip.button
    [ Chip.onClick <| Navigate <| Url.usersByGroup group
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
        [ Elevation.e2 ]
        [ Card.title
            [ cs "card-title user-card-title" ]
            [ Card.head [] [ a [ href <| Url.user user.nickname ] [ text user.nickname ] ] ]
         , Card.actions
            []
            ( List.map badge (if List.isEmpty user.groups then ["user"] else user.groups) )
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
