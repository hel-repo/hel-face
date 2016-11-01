module User.Update exposing (..)

import User.Messages exposing (Msg(..))
import User.Models exposing (UserData)


update : Msg -> UserData -> ( UserData, Cmd Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none )
    ErrorOccurred message ->
      { data
        | error = message
        , loading = False
      } ! []

    -- Network
    LogIn login password ->
      { data | loading = True } ! [ ]
    LoggedIn ->
      { data
        | loading = False
        , error = ""
      } ! [ ]

    -- Navigation
    GoToAuth ->
      data ! []

    GoToRegister ->
      data ! []