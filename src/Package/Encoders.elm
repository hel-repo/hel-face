module Package.Encoders exposing (packageEncoder)

import Array exposing (fromList)
import List exposing (map)
import Json.Encode as Json exposing (..)

import Package.Models exposing (Package)


package : Package -> Value
package pkg =
  let
    fields =
      [ ("license", string pkg.license)
      , ("description", string pkg.description)
      , ("short_description", string pkg.shortDescription)
      , ("owners", array <| fromList <| map string pkg.owners)
      , ("authors", array <| fromList <| map string pkg.authors)
      , ("tags", array <| fromList <| map string pkg.tags)
      ]
  in
    object
      ( if pkg.name /= pkg.oldName then
          ("name", string pkg.name) :: fields
        else
          fields
      )


packageEncoder : Package -> String
packageEncoder pkg =
  encode 0 <| package pkg