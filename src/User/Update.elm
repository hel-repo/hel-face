module User.Update exposing (..)

import Http exposing (Error, RawError, Response, defaultSettings)
import Json.Decode as Json
import Task exposing (Task)

import Navigation

import Base.Config as Config
import User.Decoders exposing (userDecoder, profileDecoder)
import User.Messages exposing (Msg(..))
import User.Models exposing (UserData, emptyUser)


wrapMsg : Msg -> Cmd Msg
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())


post' : String -> String -> Task RawError Response
post' url data =
  Http.send { defaultSettings | withCredentials = True }
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

logout : Cmd Msg
logout =
  post'
      (Config.apiHost ++ "auth")
      ("{ \"action\": \"log-out\" }")
    |> Task.mapError toString
    |> Task.perform (always LoggedOut) (always LoggedOut)


get' : Json.Decoder value -> String -> Task Error value
get' decoder url =
  let request =
        { verb = "GET"
        , headers = []
        , url = url
        , body = Http.empty
        }
  in Http.fromJson decoder
        <| Http.send { defaultSettings | withCredentials = True } request

fetchUser : String -> Cmd Msg
fetchUser nickname =
  get' userDecoder (Config.apiHost ++ "users/" ++ nickname)
    |> Task.mapError toString
    |> Task.perform ErrorOccurred UserFetched


checkSession : Cmd Msg
checkSession =
  get' profileDecoder (Config.apiHost ++ "profile")
    |> Task.mapError toString
    |> Task.perform ErrorOccurred SessionChecked


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
      } ! [ Navigation.newUrl "#packages", wrapMsg <| FetchUser data.user.nickname ]

    LogOut ->
      data ! [ logout ]
    LoggedOut ->
      { data | loggedin = False, user = emptyUser } ! [ Navigation.newUrl "#auth" ]

    FetchUser name ->
      data ! [ fetchUser name ]
    UserFetched user ->
      { data | user = user } ! []

    CheckSession ->
      data ! [ checkSession ]
    SessionChecked profile ->
      let user = data.user
      in { data | user = { user | nickname = profile.nickname }, loggedin = profile.loggedin }
         ! if profile.loggedin then [ wrapMsg <| FetchUser profile.nickname ] else []

    -- Navigation callbacks
    GoToAuth ->
      { data | error = "" } ! []

    GoToRegister ->
      { data | error = "" } ! []

    -- Other
    InputNickname nickname ->
      let user = data.user
      in { data | user = { user | nickname = nickname } } ! []

    InputPassword password ->
      let user = data.user
      in { data | user = { user | password = password } } ! []

    InputKey key ->
      data ! (
        if key == Config.enterKey then [ wrapMsg <| LogIn data.user.nickname data.user.password ]
        else []
      )
