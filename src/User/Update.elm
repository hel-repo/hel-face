module User.Update exposing (..)

import Http exposing (Error, RawError, Response, defaultSettings)
import Json.Decode as Json exposing ((:=))
import String exposing (isEmpty)
import Task exposing (Task)

import Base.Config as Config
import Base.Messages as Outer
import Base.Tools as Tools exposing ((~))
import User.Decoders exposing (singleUserDecoder, profileDecoder)
import User.Messages exposing (Msg(..))
import User.Models exposing (User, UserData, emptyUser)


wrapMsg : Msg -> Cmd Msg
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())


post' : String -> String -> Task RawError Response
post' url data =
  Http.send { defaultSettings | withCredentials = True }
    { verb = "POST"
    , headers = [ ("Content-Type", "application/json; charset=UTF-8") ]
    , url = url
    , body = Http.string data
    }

parseAuthResult : Response -> Msg
parseAuthResult response =
  case response.status of
    200 -> LoggedIn
    _ -> ErrorOccurred "Looks like either your nickname or password were incorrect. Wanna try again?"


-- TODO: simplify this
fromJson' : Json.Decoder String -> Task RawError Response -> Task Error String
fromJson' decoder response =
  let decode str =
        case Json.decodeString decoder str of
          Ok v -> Task.succeed v
          Err msg -> Task.fail (Http.UnexpectedPayload msg)
  in
    Task.mapError promoteError response
      `Task.andThen` handleResponse decode

handleResponse : (String -> Task Error String) -> Response -> Task Error String
handleResponse handle response =
  case response.status of
    200 ->
      Task.succeed ""
    _ ->
      case response.value of
        Http.Text str ->
            handle str
        _ ->
            Task.fail (Http.UnexpectedPayload "Response body is a blob, expecting a string.")

promoteError : RawError -> Error
promoteError rawError =
  case rawError of
    Http.RawTimeout -> Http.Timeout
    Http.RawNetworkError -> Http.NetworkError

registerResponseDecoder : Json.Decoder String
registerResponseDecoder =
  "message" := Json.string

parseRegisterResult : String -> Msg
parseRegisterResult response =
  if isEmpty response then
    Registered
  else
    ErrorOccurred <| "Sorry! " ++ response ++ " Wanna try again?"
--


login : String -> String -> Cmd Msg
login nickname password =
  post'
      (Config.apiHost ++ "auth")
      ("{ \"action\": \"log-in\", \"nickname\": \"" ++ nickname ++ "\", \"password\": \"" ++ password ++ "\"}")
    |> Task.mapError toString
    |> Task.perform ErrorOccurred parseAuthResult

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
  get' singleUserDecoder (Config.apiHost ++ "users/" ++ nickname)
    |> Task.mapError toString
    |> Task.perform ErrorOccurred UserFetched


checkSession : Cmd Msg
checkSession =
  get' profileDecoder (Config.apiHost ++ "profile")
    |> Task.mapError toString
    |> Task.perform ErrorOccurred SessionChecked

register : User -> Cmd Msg
register user =
  fromJson' registerResponseDecoder
    ( post'
        (Config.apiHost ++ "auth")
        ("{ \"action\": \"register\",
            \"nickname\": \"" ++ user.nickname ++ "\",
            \"email\": \"" ++ user.email ++ "\",
            \"password\": \"" ++ user.password ++ "\" }") )
    |> Task.mapError toString
    |> Task.perform ErrorOccurred parseRegisterResult


update : Msg -> UserData -> ( UserData, Cmd Msg, List Outer.Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none, [] )
    ErrorOccurred message ->
      { data
        | loggedin = False
        , loading = False
      } ! [] ~ [ Outer.ErrorOccurred message ]

    -- Network
    LogIn nickname password ->
      { data | loading = True } ! [ login nickname password ] ~ []
    LoggedIn ->
      { data
        | loggedin = True
        , loading = False
      }
      ! [ wrapMsg <| FetchUser data.user.nickname ]
      ~ [ Outer.Navigate "#packages" ]

    LogOut ->
      { data | loading = True } ! [ logout ] ~ []
    LoggedOut ->
      { data | loading = False, loggedin = False, user = emptyUser } ! [] ~ [ Outer.Navigate "#auth" ]

    FetchUser name ->
      data ! [ fetchUser name ] ~ []
    UserFetched user ->
      { data | user = user } ! [] ~ []

    CheckSession ->
      data ! [ checkSession ] ~ []
    SessionChecked profile ->
      let user = data.user
      in { data | user = { user | nickname = profile.nickname }, loggedin = profile.loggedin }
         ! ( if profile.loggedin then [ wrapMsg <| FetchUser profile.nickname ] else [] ) ~ []

    Register user ->
      { data | loading = True } ! [ register user ] ~ []
    Registered ->
      { data | loading = False }
      ! []
      ~ [ Outer.Navigate "#auth", Outer.SomethingOccurred "You have registered successfully!" ]

    -- Navigation callbacks
    GoToAuth ->
      data ! [] ~ []

    GoToRegister ->
      data ! [] ~ []

    -- Other
    InputNickname nickname ->
      let user = data.user
      in { data | user = { user | nickname = nickname } } ! [] ~ []
    InputPassword password ->
      let user = data.user
      in { data | user = { user | password = password } } ! [] ~ []
    InputRetryPassword password ->
      let user = data.user
      in { data | user = { user | retryPassword = password } } ! [] ~ []
    InputEmail email ->
      let user = data.user
      in { data | user = { user | email = email } } ! [] ~ []

    InputKey key ->
      data ! (
        if key == Config.enterKey then [ wrapMsg <| LogIn data.user.nickname data.user.password ]
        else []
      ) ~ []
