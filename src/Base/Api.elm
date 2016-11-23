module Base.Api exposing (..)

import Http
import String

import Base.Config as Config
import Base.Decoders exposing (..)
import Base.Encoders exposing (packageEncoder, userEncoder)
import Base.Http exposing (..)
import Base.Models exposing (ApiResult, Package, emptyPackage, Session, User)
import Base.Search exposing (SearchData, searchApiPath)


-- Global state
-----------------------------------------------------------------------------------
checkSession : (Result Http.Error Session -> a) -> Cmd a
checkSession msg =
  Http.send msg
    <| xget (Config.apiHost ++ "profile") sessionDecoder


-- Packages
-----------------------------------------------------------------------------------
fetchPackage : String -> (Result Http.Error Package -> a) -> Cmd a
fetchPackage name msg =
  Http.send msg
    <| xget (Config.apiHost ++ "packages/" ++ name) singlePackageDecoder

fetchPackages : SearchData -> (Result Http.Error (List Package) -> a) -> Cmd a
fetchPackages data msg =
  Http.send msg
    <| xget
         ( Config.apiHost
           ++ "packages"
           ++ (searchApiPath data)
         )
         packagesDecoder

savePackage : Package -> Package -> (Result Http.Error ApiResult -> a) -> Cmd a
savePackage package oldPackage msg =
  let
    name = if String.isEmpty oldPackage.name then package.name else oldPackage.name
  in
    Http.send msg
      <| xpatch
           ( Config.apiHost ++ "packages/" ++ name )
           ( packageEncoder package oldPackage )

createPackage : Package -> (Result Http.Error ApiResult -> a) -> Cmd a
createPackage package msg =
  Http.send msg
    <| xpost
         ( Config.apiHost ++ "packages/" )
         ( packageEncoder package emptyPackage )

removePackage : String -> (Result Http.Error ApiResult -> a) -> Cmd a
removePackage name msg =
  Http.send msg
    <| xdelete ( Config.apiHost ++ "packages/" ++ name )


-- Users
-----------------------------------------------------------------------------------
register : User -> (Result Http.Error ApiResult -> a) -> Cmd a
register user msg =
  Http.send msg
    <| xpost
         ( Config.apiHost ++ "auth" )
         ( "{ \"action\": \"register\", \"nickname\": \"" ++ user.nickname
           ++ "\", \"email\": \"" ++ user.email
           ++ "\", \"password\": \"" ++ user.password
           ++ "\" }" )

login : String -> String -> (Result Http.Error ApiResult -> a) -> Cmd a
login nickname password msg =
  Http.send msg
    <| xpost
         (Config.apiHost ++ "auth")
         ("{ \"action\": \"log-in\", \"nickname\": \""
          ++ nickname ++ "\", \"password\": \"" ++ password ++ "\"}")

logout : (Result Http.Error ApiResult -> a) -> Cmd a
logout msg =
  Http.send msg
    <| xpost (Config.apiHost ++ "auth") ("{ \"action\": \"log-out\" }")

fetchUser : String -> (Result Http.Error User -> a) -> Cmd a
fetchUser nickname msg =
  Http.send msg
    <| xget (Config.apiHost ++ "users/" ++ nickname) singleUserDecoder

fetchUsers : (Result Http.Error (List User) -> a) -> Cmd a
fetchUsers msg =
  Http.send msg
    <| xget ( Config.apiHost ++ "users" ) usersDecoder

fetchUsersByGroup : String -> (Result Http.Error (List User) -> a) -> Cmd a
fetchUsersByGroup group msg =
  Http.send msg
    <| xget ( Config.apiHost ++ "users?groups=" ++ group ) usersDecoder

saveUser : User -> String -> (Result Http.Error ApiResult -> a) -> Cmd a
saveUser user oldNickname msg =
  Http.send msg
    <| xpatch ( Config.apiHost ++ "users/" ++ oldNickname ) ( userEncoder user )

removeUser : String -> (Result Http.Error ApiResult -> a) -> Cmd a
removeUser nickname msg =
  Http.send msg
    <| xdelete ( Config.apiHost ++ "users/" ++ nickname )
