module Base.Url exposing (..)

search : String -> String
search query = "#search/" ++ query

packages : String
packages = "#packages/"

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
