module User.Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import List exposing (isEmpty, map)

import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Options as Options exposing (cs)
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import User.Models exposing (UserData)


badge : String -> Html Msg
badge group =
  Chip.button
    [ cs (if group == "admins" then "admin-badge" else "user-badge" ) ]
    [ Chip.content []
        [ text group ]
    ]

subtitle : String -> Html Msg
subtitle str =
  Options.styled p [ Typo.button, cs "subtitle" ] [ text str ]

profile : UserData -> Html Msg
profile data =
  Card.view
    [ Elevation.e3 ]
    [ Card.title [ Card.border ] [ Card.head [] [ text "Profile" ] ]
    , Card.text [ cs "profile-panel" ]
      [ div [ class "profile-avatar" ] [ Icon.view "account_circle" [ cs "avatar" ] ]
      , div [ class "profile-info" ]
          [ subtitle "Nickname"
          , div
              [ class "profile-nickname" ]
              [ text data.user.nickname ]
          , subtitle "Groups"
          , div
              [ class "profile-badges" ]
              ( map badge (if isEmpty data.user.groups then ["user"] else data.user.groups) )
          ]
      ]
    ]

packages : UserData -> Html Msg
packages data =
  Card.view
    [ Elevation.e2
    , cs "profile-packages"
    ]
    [ Card.title [ Card.border ] [ Card.head [] [ text "My packages" ] ]
    , Card.actions
        []
        []
    ]


view : UserData -> Html Msg
view data =
  div
    [ class "page" ]
    [ grid [ ]
        [ cell [ size All 2, size Tablet 0 ] [ ]
        , cell [ size All 8, size Tablet 8 ] [ profile data, packages data ]
        , cell [ size All 2, size Tablet 0 ] [ ]
        ]
    ]