module Base.Network.Url exposing (..)

import Http exposing (encodeUri)
import Base.Helpers.Search exposing (prefixedWord)


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

users : String
users = "#users"

usersByGroup : String -> String
usersByGroup group = "#users/" ++ ( if group == "user" then "" else group )

about : String
about = "#about"
