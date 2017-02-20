module User.View.Auth exposing (..)

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

import Base.Json.Input exposing (keyDecoder)
import Base.Messages exposing (Msg(..))
import Base.Network.Url as Url
import User.Localization as L
import User.Messages as UMsg
import User.Models exposing (UserData)


auth : UserData -> Html Msg
auth data =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ] [ Card.head [] [ text (L.get data.session.lang L.authorization) ] ]
    , Card.text []
      [ div []
          [ Textfield.render Mdl [3] data.mdl
              [ Textfield.label (L.get data.session.lang L.nickname)
              , Textfield.floatingLabel
              , Textfield.text_
              , Textfield.value data.user.nickname
              , Options.onInput <| UMsg.InputNickname >> UserMsg
              , if data.validate && String.isEmpty data.user.nickname then
                  Textfield.error (L.get data.session.lang L.cantBeEmpty)
                else
                  Options.nop
              ] []
          ]
      , div []
          [ Textfield.render Mdl [4] data.mdl
              [ Textfield.label (L.get data.session.lang L.password)
              , Textfield.floatingLabel
              , Textfield.password
              , Textfield.value data.user.password
              , Options.onInput <| UMsg.InputPassword >> UserMsg
              , Options.on "keyup" <| keyDecoder (UMsg.InputKey >> UserMsg)
              , if data.validate && String.isEmpty data.user.password then
                  Textfield.error (L.get data.session.lang L.cantBeEmpty)
                else
                  Options.nop
              ] []
          ]
      , div [ class "profile-panel" ]
          [ Button.render Mdl [5] data.mdl
              [ Button.raised
              , Button.ripple
              , Options.onClick <| UserMsg (UMsg.LogIn data.user.nickname data.user.password)
              ]
              [ text (L.get data.session.lang L.login)]
          , Options.styled p
              [ Typo.subhead, cs "auth-alter" ]
              [ text (L.get data.session.lang L.or) ]
          , Options.styled p
              [ Typo.subhead, cs "auth-alter" ]
              [ a [ href Url.register ] [ text (L.get data.session.lang L.register) ] ]
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
