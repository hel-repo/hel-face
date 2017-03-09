module Base.Network.Url exposing (..)

import Http exposing (encodeUri)
import Base.Helpers.Search exposing (prefixedWord)


home: String
home = packages Nothing Nothing

packages : Maybe String -> Maybe Int -> String
packages query page =
  let
    q = prefixedWord "search=" (encodeUri <| Maybe.withDefault "" query)
    p = case page of
          Just number -> "page=" ++ (toString number)
          Nothing -> ""
    params = String.join "&" (List.filter (not << String.isEmpty) [q, p])
  in
    (if String.isEmpty params then "" else "?" ++ params) ++ "#packages"

package : String -> String
package name = "#packages/" ++ name

edit : String -> String
edit name = "#edit/" ++ name

auth : String
auth = "#auth"

register : String
register = "#register"

profile : String
profile = "#profile"

user : String -> String
user nickname = "#profile/" ++ nickname

editUser : String -> String
editUser nickname = "#uedit/" ++ nickname

users : Maybe String -> Maybe Int -> String
users group page =
  let
    g = prefixedWord "group=" (encodeUri <| Maybe.withDefault "" group)
    p = case page of
          Just number -> "page=" ++ (toString number)
          Nothing -> ""
    params = String.join "&" (List.filter (not << String.isEmpty) [g, p])
  in
    (if String.isEmpty params then "" else "?" ++ params) ++ "#users"

about : String
about = "#about"
