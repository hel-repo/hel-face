module Base.Network.Api exposing (..)

import Http
import String

import Base.Config as Config
import Base.Helpers.Search exposing (PackagePage, PackageQuery, prefixedWord, UserPage)
import Base.Json.Decoders exposing (..)
import Base.Json.Encoders exposing (packageEncoder, userEncoder)
import Base.Network.Http exposing (..)
import Base.Models.Network exposing (ApiResult, Page)
import Base.Models.Package exposing (Package, emptyPackage)
import Base.Models.User exposing (User, Session)


-- Global state
-----------------------------------------------------------------------------------
checkSession : (Result Http.Error Session -> a) -> Cmd a
checkSession msg =
  Http.send msg
    <| xget (Config.apiHost ++ "profile") sessionDecoder

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


-- Packages
-----------------------------------------------------------------------------------
packageSearchParams : PackagePage -> String
packageSearchParams page =
  let
    query = page.query
    names = List.map ( prefixedWord "q=" ) query.names
    tags = List.map ( prefixedWord "tags=" ) query.tags
    authors = List.map ( prefixedWord "authors=" ) query.authors
    owners = List.map ( prefixedWord "owners=" ) query.owners
    tokens = List.concat [names, tags, authors, owners]
    params = String.join "&" (List.filter (not << String.isEmpty) tokens)
  in
    "?offset=" ++ (toString page.offset) ++ (if String.isEmpty params then "" else "&" ++ params)

fetchPackage : String -> (Result Http.Error Package -> a) -> Cmd a
fetchPackage name msg =
  Http.send msg
    <| xget (Config.apiHost ++ "packages/" ++ name) singlePackageDecoder

fetchPackages : PackagePage -> (Result Http.Error PackagePage -> a) -> Cmd a
fetchPackages page msg =
  Http.send msg
    <| xget ( Config.apiHost ++ "packages" ++ (packageSearchParams page) ) packagesPageDecoder

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
userSearchParams : UserPage -> String
userSearchParams page =
  let
    group = page.query.group
  in
    "?offset=" ++ (toString page.offset)
               ++ (if not <| String.isEmpty group then "&groups=" ++ group else "")

fetchUser : String -> (Result Http.Error User -> a) -> Cmd a
fetchUser nickname msg =
  Http.send msg
    <| xget (Config.apiHost ++ "users/" ++ nickname) singleUserDecoder

fetchUsers : UserPage -> (Result Http.Error UserPage -> a) -> Cmd a
fetchUsers page msg =
  Http.send msg
    <| xget ( Config.apiHost ++ "users" ++ (userSearchParams page) ) usersPageDecoder

saveUser : User -> String -> (Result Http.Error ApiResult -> a) -> Cmd a
saveUser user oldNickname msg =
  Http.send msg
    <| xpatch ( Config.apiHost ++ "users/" ++ oldNickname ) ( userEncoder user oldNickname )

removeUser : String -> (Result Http.Error ApiResult -> a) -> Cmd a
removeUser nickname msg =
  Http.send msg
    <| xdelete ( Config.apiHost ++ "users/" ++ nickname )
