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
