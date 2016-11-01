module User.Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)

import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Options as Options exposing (cs)
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import User.Models exposing (UserData)


white : Options.Property c m
white =
  Color.text Color.white

profile : UserData -> Html Msg
profile data =
  div
    [ class "page auth-card" ]
    [ Card.view
        [ Elevation.e2 ]
        [ Card.title [ Card.border ] [ Card.head [ white ] [ text "Profile" ] ]
        , Card.actions [ ]
          [ Icon.view "account_circle" [ cs "avatar" ]
          , Options.styled p
              [ Typo.subhead, cs "profile-nickname" ]
              [ text data.nickname ]
          , div [ ]
              [ Button.render Mdl [10] data.mdl
                  [ Button.raised
                  , Button.ripple
                  , cs "profile-button"
                  ]
                  [ Icon.i "mode_edit", text "Edit"]
              , Button.render Mdl [11] data.mdl
                  [ Button.raised
                  , Button.ripple
                  , cs "profile-button"
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
    [ div
        [ class "error" ]
        [ text data.error ]
    , grid [ ]
        [ cell [ size All 3, size Tablet 0 ] [ ]
        , cell [ size All 6, size Tablet 8 ] [ profile data ]
        , cell [ size All 3, size Tablet 0 ] [ ]
        ]
    ]