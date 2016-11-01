module User.Update exposing (..)

import Http exposing (RawError, Response)
import Task exposing (Task)

import Navigation

import Base.Config as Config
import User.Messages exposing (Msg(..))
import User.Models exposing (UserData)


wrapMsg : Msg -> Cmd Msg
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())


post' : String -> String -> Task RawError Response
post' url data =
    Http.send Http.defaultSettings
    { verb = "POST"
    , headers = []
    , url = url
    , body = Http.string data
    }

parseResult : Response -> Msg
parseResult response =
  case response.status of
    200 -> LoggedIn
    _ -> ErrorOccurred "Looks like either your nickname or password were incorrect. Wanna try again?"


login : String -> String -> Cmd Msg
login nickname password =
  post'
      (Config.apiHost ++ "auth")
      ("{ \"action\": \"log-in\", \"nickname\": \"" ++ nickname ++ "\", \"password\": \"" ++ password ++ "\"}")
    |> Task.mapError toString
    |> Task.perform ErrorOccurred parseResult


update : Msg -> UserData -> ( UserData, Cmd Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none )
    ErrorOccurred message ->
      { data
        | loggedin = False
        , error = message
        , loading = False
      } ! []

    -- Network
    LogIn nickname password ->
      { data | loading = True } ! [ login nickname password ]
    LoggedIn ->
      { data
        | loggedin = True
        , loading = False
        , error = ""
      } ! [ Navigation.newUrl "#packages" ]

    -- Navigation callbacks
    GoToAuth ->
      data ! []

    GoToRegister ->
      data ! []

    -- Other
    InputNickname nickname ->
      { data | nickname = nickname } ! []

    InputPassword password ->
      { data | password = password } ! []

    InputKey key ->
      data ! (
        if key == 13 then [ wrapMsg <| LogIn data.nickname data.password ]
        else []
      )
