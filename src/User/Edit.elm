module User.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)

import Material.Button as Button
import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading
import Material.Textfield as Textfield

import Base.Input exposing (keyDecoder)
import Base.Messages exposing (Msg(..))
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
            [ Textfield.label "Nickname"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value data.user.nickname
            , Textfield.onInput <| UMsg.InputNickname >> UserMsg
            , if data.validate && String.isEmpty data.user.nickname then
                Textfield.error "User can not be nameless!"
              else
                Options.nop
            , cs "edit-card-title"
            ]
        ]
    , Card.text
        [ Card.border ]
        [ subtitle "To add a group, enter the name and then press Enter"
        , Textfield.render Mdl [15] data.mdl
            [ Textfield.label "User group"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value data.groupTag
            , Textfield.onInput <| UMsg.InputGroup >> UserMsg
            , Textfield.on "keyup" <| keyDecoder (UMsg.InputKey >> UserMsg)
            ]
        , div [] ( List.map chip data.user.groups )
        ]
    , Card.text
        []
        [ Button.render Mdl [60] data.mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Button.onClick <| UserMsg ( UMsg.SaveUser data.user )
            , cs "save-button"
            ]
            [ text "Save" ]
        , Button.render Mdl [61] data.mdl
            [ Button.raised
            , Button.ripple
            , Button.onClick <| Back
            ]
            [ text "Cancel" ]
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
