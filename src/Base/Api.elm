module Base.Api exposing (..)

import Http
import Json.Decode as Json exposing ((:=))
import String
import Task

import Base.Config as Config
import Base.Http exposing (..)
import Base.Search exposing (SearchData, searchApiPath)
import Package.Decoders exposing (singlePackageDecoder, packagesDecoder)
import Package.Encoders exposing (packageEncoder)
import Package.Models exposing (Package, emptyPackage)
import User.Decoders exposing (singleUserDecoder, profileDecoder)
import User.Models exposing (User, Profile)


-- Packages
------------------------------------------------------------------------------------------------------------------------

fetchPackage : String -> (String -> a) -> (Package -> a) -> Cmd a
fetchPackage name errorMessage successMessage =
  Http.get singlePackageDecoder (Config.apiHost ++ "packages/" ++ name)
    |> Task.mapError toString
    |> Task.perform errorMessage successMessage

fetchPackages : SearchData -> (String -> a) -> (List Package -> a) -> Cmd a
fetchPackages data errorMessage successMessage =
  Http.get packagesDecoder
    ( Config.apiHost
      ++ "packages"
      ++ (searchApiPath data)
    )
    |> Task.mapError toString
    |> Task.perform errorMessage successMessage

savePackage : Package -> Package -> (String -> a) -> (Http.Response -> a) -> Cmd a
savePackage package oldPackage errorMessage successMessage =
  let
    name = if String.isEmpty oldPackage.name then package.name else oldPackage.name
  in
    xpatch
      ( Config.apiHost ++ "packages/" ++ name )
      ( packageEncoder package oldPackage )
      |> Task.mapError toString
      |> Task.perform errorMessage successMessage

createPackage : Package -> (String -> a) -> (Http.Response -> a) -> Cmd a
createPackage package errorMessage successMessage =
  xpost
      ( Config.apiHost ++ "packages/" )
      ( packageEncoder package emptyPackage )
      |> Task.mapError toString
      |> Task.perform errorMessage successMessage

removePackage : String -> (String -> a) -> (Http.Response -> a) -> Cmd a
removePackage name errorMessage successMessage =
  xdelete
      ( Config.apiHost ++ "packages/" ++ name )
      |> Task.mapError toString
      |> Task.perform errorMessage successMessage


-- Users
------------------------------------------------------------------------------------------------------------------------

-- TODO: simplify this --
xfromJson : Json.Decoder String -> Task.Task Http.RawError Http.Response -> Task.Task Http.Error String
xfromJson decoder response =
  let decode str =
        case Json.decodeString decoder str of
          Ok v -> Task.succeed v
          Err msg -> Task.fail (Http.UnexpectedPayload msg)
  in
    Task.mapError promoteError response
      `Task.andThen` handleResponse decode

handleResponse : (String -> Task.Task Http.Error String) -> Http.Response -> Task.Task Http.Error String
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

promoteError : Http.RawError -> Http.Error
promoteError rawError =
  case rawError of
    Http.RawTimeout -> Http.Timeout
    Http.RawNetworkError -> Http.NetworkError

registerResponseDecoder : Json.Decoder String
registerResponseDecoder =
  "message" := Json.string

parseRegisterResult : (String -> a) -> a -> String -> a
parseRegisterResult errorMessage successMessage response =
  if String.isEmpty response then
    successMessage
  else
    errorMessage <| "Sorry! " ++ response ++ " Wanna try again?"
----
register : User -> (String -> a) -> a -> Cmd a
register user errorMessage successMessage =
  xfromJson registerResponseDecoder
    ( xpost
        (Config.apiHost ++ "auth")
        ("{ \"action\": \"register\",
            \"nickname\": \"" ++ user.nickname ++ "\",
            \"email\": \"" ++ user.email ++ "\",
            \"password\": \"" ++ user.password ++ "\" }") )
    |> Task.mapError toString
    |> Task.perform errorMessage (parseRegisterResult errorMessage successMessage)


parseAuthResult : (String -> a) -> a -> Http.Response -> a
parseAuthResult errorMessage successMessage response =
  case response.status of
    200 -> successMessage
    _ -> errorMessage "Looks like either your nickname or password were incorrect. Wanna try again?"

login : String -> String -> (String -> a) -> a -> Cmd a
login nickname password errorMessage successMessage =
  xpost
      (Config.apiHost ++ "auth")
      ("{ \"action\": \"log-in\", \"nickname\": \"" ++ nickname ++ "\", \"password\": \"" ++ password ++ "\"}")
    |> Task.mapError toString
    |> Task.perform errorMessage (parseAuthResult errorMessage successMessage)


logout : (String -> a) -> a -> Cmd a
logout errorMessage successMessage =
  xpost
      (Config.apiHost ++ "auth")
      ("{ \"action\": \"log-out\" }")
    |> Task.mapError toString
    |> Task.perform (always successMessage) (always successMessage)


fetchUser : String -> (String -> a) -> (User -> a) -> Cmd a
fetchUser nickname errorMessage successMessage =
  xget singleUserDecoder (Config.apiHost ++ "users/" ++ nickname)
    |> Task.mapError toString
    |> Task.perform errorMessage successMessage


checkSession : (String -> a) -> (Profile -> a) -> Cmd a
checkSession errorMessage successMessage =
  xget profileDecoder (Config.apiHost ++ "profile")
    |> Task.mapError toString
    |> Task.perform errorMessage successMessage
