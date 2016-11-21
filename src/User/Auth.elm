module User.Auth exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)

import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Spinner as Loading
import Material.Options as Options exposing (cs)
import Material.Textfield as Textfield
import Material.Typography as Typo

import Base.Input exposing (keyDecoder)
import Base.Messages exposing (Msg(..))
import Base.Url as Url
import User.Messages as UMsg
import User.Models exposing (UserData)


auth : UserData -> Html Msg
auth data =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ] [ Card.head [] [ text "Authorization" ] ]
    , Card.text []
      [ div []
          [ Textfield.render Mdl [3] data.mdl
              [ Textfield.label "Nickname"
              , Textfield.floatingLabel
              , Textfield.text_
              , Textfield.value data.user.nickname
              , Textfield.onInput <| UMsg.InputNickname >> UserMsg
              , if data.validate && String.isEmpty data.user.nickname then
                  Textfield.error "Can't be empty"
                else
                  Options.nop
              ]
          ]
      , div []
          [ Textfield.render Mdl [4] data.mdl
            [ Textfield.label "Password"
            , Textfield.floatingLabel
            , Textfield.password
            , Textfield.value data.user.password
            , Textfield.onInput <| UMsg.InputPassword >> UserMsg
            , Textfield.on "keyup" <| keyDecoder (UMsg.InputKey >> UserMsg)
            , if data.validate && String.isEmpty data.user.password then
                Textfield.error "Can't be empty"
              else
                Options.nop
            ]
          ]
      , div [ class "profile-panel" ]
          [ Button.render Mdl [5] data.mdl
              [ Button.raised
              , Button.ripple
              , Button.onClick <| UserMsg (UMsg.LogIn data.user.nickname data.user.password)
              ]
              [ text "Log In"]
          , Options.styled p
              [ Typo.subhead, cs "auth-alter" ]
              [ text "or" ]
          , Options.styled p
              [ Typo.subhead, cs "auth-alter" ]
              [ a [ href Url.register ] [ text "register" ] ]
          ]
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
    div
      [ class "page auth-card" ]
      [ grid []
          [ cell [ size All 3, size Tablet 0 ] [ ]
          , cell [ size All 6, size Tablet 8 ] [ auth data ]
          , cell [ size All 3, size Tablet 0 ] [ ]
          ]
      ]