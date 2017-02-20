module User.View.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)

import Material.Button as Button
import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading
import Material.Textfield as Textfield

import Base.Json.Input exposing (keyDecoder)
import Base.Messages exposing (Msg(..))
import User.Localization as L
import User.Messages as UMsg
import User.Models exposing (UserData)


subtitle : String -> Html Msg
subtitle str =
  div [] [ text str ]

chip : String -> Html Msg
chip str =
  Chip.span
    [ Chip.deleteIcon "cancel"
    , Chip.deleteClick <| UserMsg ( UMsg.RemoveGroup str )
    , cs "noselect"
    ]
    [ Chip.content [] [ text str ] ]

card : UserData -> Html Msg
card data =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ]
        [ Textfield.render Mdl [11] data.mdl
            [ Textfield.label (L.get data.session.lang L.nickname)
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value data.user.nickname
            , Options.onInput <| UMsg.InputNickname >> UserMsg
            , if data.validate && String.isEmpty data.user.nickname then
                Textfield.error (L.get data.session.lang L.cannotBeNameless)
              else
                Options.nop
            , cs "edit-card-title"
            ] []
        ]
    , Card.text
        [ Card.border ]
        [ subtitle (L.get data.session.lang L.leaveEmpty)
        , div []
            [ Textfield.render Mdl [12] data.mdl
              [ Textfield.label (L.get data.session.lang L.password)
              , Textfield.floatingLabel
              , Textfield.password
              , Textfield.value data.user.password
              , Options.onInput <| UMsg.InputPassword >> UserMsg
              ] []
            ]
        , div []
            [ Textfield.render Mdl [13] data.mdl
              [ Textfield.label (L.get data.session.lang L.retryPassword)
              , Textfield.floatingLabel
              , Textfield.password
              , Textfield.value data.user.retryPassword
              , Options.onInput <| UMsg.InputRetryPassword >> UserMsg
              , if (not <| data.user.password == data.user.retryPassword)
                && ((not <| String.isEmpty data.user.retryPassword) || data.validate) then
                  Textfield.error <| (L.get data.session.lang L.doesNotMatch)
                else
                  Options.nop
              ] []
            ]
        ]
    , Card.text
        [ Card.border ]
        [ subtitle (L.get data.session.lang L.toAddGroup)
        , Textfield.render Mdl [15] data.mdl
            [ Textfield.label (L.get data.session.lang L.userGroup)
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value data.groupTag
            , Options.onInput <| UMsg.InputGroup >> UserMsg
            , Options.on "keyup" <| keyDecoder (UMsg.InputKey >> UserMsg)
            ] []
        , div [] ( List.map chip data.user.groups )
        ]
    , Card.text
        []
        [ Button.render Mdl [60] data.mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Options.onClick <| UserMsg ( UMsg.SaveUser data.user )
            , cs "save-button"
            ]
            [ text (L.get data.session.lang L.save) ]
        , Button.render Mdl [61] data.mdl
            [ Button.raised
            , Button.ripple
            , Options.onClick <| Back
            ]
            [ text (L.get data.session.lang L.cancel) ]
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
      [ class "page" ]
      [ card data ]
