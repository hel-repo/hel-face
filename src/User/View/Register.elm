module User.View.Register exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import String exposing (isEmpty)

import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading
import Material.Textfield as Textfield
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import Base.Network.Url as Url
import User.Messages as UMsg
import User.Models exposing (UserData)


register : UserData -> Html Msg
register data =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ] [ Card.head [] [ text "Registration" ] ]
    , Card.text [ ]
      [ div [ ]
          [ Textfield.render Mdl [10] data.mdl
              [ Textfield.label "Nickname"
              , Textfield.floatingLabel
              , Textfield.text_
              , Textfield.value data.user.nickname
              , Options.onInput <| UMsg.InputNickname >> UserMsg
              , if data.validate && isEmpty data.user.nickname then
                  Textfield.error "Can't be empty"
                else
                  Options.nop
              ] []
          ]
      , div [ ]
          [ Textfield.render Mdl [11] data.mdl
              [ Textfield.label "E-mail"
              , Textfield.floatingLabel
              , Textfield.text_
              , Textfield.value data.user.email
              , Options.onInput <| UMsg.InputEmail >> UserMsg
              , if data.validate && isEmpty data.user.email then
                  Textfield.error "Can't be empty"
                else
                  Options.nop
              ] []
          ]
      , div [ ]
          [ Textfield.render Mdl [12] data.mdl
            [ Textfield.label "Password"
            , Textfield.floatingLabel
            , Textfield.password
            , Textfield.value data.user.password
            , Options.onInput <| UMsg.InputPassword >> UserMsg
            , if data.validate && isEmpty data.user.password then
                Textfield.error "Can't be empty"
              else
                Options.nop
            ] []
          ]
      , div [ ]
          [ Textfield.render Mdl [13] data.mdl
            [ Textfield.label "Retype the password"
            , Textfield.floatingLabel
            , Textfield.password
            , Textfield.value data.user.retryPassword
            , Options.onInput <| UMsg.InputRetryPassword >> UserMsg
            , if (not <| data.user.password == data.user.retryPassword)
              && ((not <| isEmpty data.user.retryPassword) || data.validate) then
                Textfield.error <| "Doesn't match password!"
              else
                Options.nop
            ] []
          ]
      , div [ class "profile-panel" ]
          [ Button.render Mdl [14] data.mdl
              [ Button.raised
              , Button.ripple
              , Options.onClick <| UserMsg (UMsg.Register data.user)
              ]
              [ text "Register"]
          , Options.styled p
              [ Typo.subhead, cs "auth-alter" ]
              [ text "or" ]
          , Options.styled p
              [ Typo.subhead, cs "auth-alter" ]
              [ a [ href Url.auth ] [ text "log in" ] ]
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
      [ grid [ ]
          [ cell [ size All 3, size Tablet 0 ] [ ]
          , cell [ size All 6, size Tablet 8 ] [ register data ]
          , cell [ size All 3, size Tablet 0 ] [ ]
          ]
      ]