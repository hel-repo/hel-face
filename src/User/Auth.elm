module User.Auth exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Options as Options exposing (cs)
import Material.Textfield as Textfield
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import User.Models exposing (UserData)


white : Options.Property c m
white =
  Color.text Color.white

auth : UserData -> Html Msg
auth data =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ] [ Card.head [ white ] [ text "Authorization" ] ]
    , Card.text [ ]
      [ div [ ]
          [ Textfield.render Mdl [3] data.mdl
              [ Textfield.label "Nickname"
              , Textfield.floatingLabel
              , Textfield.text'
              ]
          ]
      , div [ ]
          [ Textfield.render Mdl [4] data.mdl
            [ Textfield.label "Password"
            , Textfield.floatingLabel
            , Textfield.password
            ]
          ]
      , div [ ]
          [ Button.render Mdl [5] data.mdl
              [ Button.raised
              , Button.ripple
              ]
              [ text "Log In"]
          , Options.styled p
              [ Typo.subhead, white, cs "auth-alter" ]
              [ text "or" ]
          , Options.styled p
              [ Typo.subhead, white, cs "auth-alter" ]
              [ a [ href "#register" ] [ text "register" ] ]
          ]
      ]
    ]


view : UserData -> Html Msg
view data =
  div
    [ class "page auth-card" ]
    [ grid [ ]
      [ cell [ size All 3, size Tablet 0 ] [ ]
      , cell [ size All 6, size Tablet 8 ] [ auth data ]
      , cell [ size All 3, size Tablet 0 ] [ ]
      ]
    ]