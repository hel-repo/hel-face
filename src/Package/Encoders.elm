module Package.Encoders exposing (packageEncoder)

import Json.Encode as Json exposing (..)

import Package.Models exposing (Package)


package : Package -> Value
package pkg =
  object
    [ ("name", string pkg.name)
    ]

packageEncoder : Package -> String
packageEncoder pkg =
  encode 0 <| package pkg