module User.Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import List exposing (map)

import Material.Button as Button
import Material.Card as Card
import Material.Chip as Chip
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Options as Options exposing (cs)
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import User.Messages as UMsg
import User.Models exposing (UserData)


badge : String -> Html Msg
badge group =
  Chip.button
    [ cs (if group == "admins" then "admin-badge" else "user-badge" ) ]
    [ Chip.content []
        [ text group ]
    ]

profile : UserData -> Html Msg
profile data =
  div
    [ class "page auth-card" ]
    [ Card.view
        [ Elevation.e2 ]
        [ Card.title [ Card.border ] [ Card.head [] [ text "Profile" ] ]
        , Card.actions [ ]
          [ Icon.view "account_circle" [ cs "avatar" ]
          , div [ class "badges" ]
              ( map badge data.user.groups )
          , Options.styled p
              [ Typo.subhead, cs "profile-nickname" ]
              [ text data.user.nickname ]
          , div [ ]
              [ Button.render Mdl [11] data.mdl
                  [ Button.raised
                  , Button.ripple
                  , cs "profile-button"
                  , Button.onClick <| UserMsg UMsg.LogOut
                  ]
                  [ Icon.i "close", text "Log Out"]
              ]
          ]
        ]
    ]

view : UserData -> Html Msg
view data =
  div
    [ class "page auth-card" ]
    [ grid [ ]
        [ cell [ size All 3, size Tablet 0 ] [ ]
        , cell [ size All 6, size Tablet 8 ] [ profile data ]
        , cell [ size All 3, size Tablet 0 ] [ ]
        ]
    ]