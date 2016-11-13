module Package.Encoders exposing (packageEncoder)

import Array exposing (fromList)
import List exposing (map)
import Json.Encode as Json exposing (..)

import Package.Models exposing (Package, Version, PkgVersionDependency, PkgVersionFile)


file : PkgVersionFile -> Value
file f =
  object
    [ ("dir", string f.dir)
    , ("name", string f.name)
    ]

dependency : PkgVersionDependency -> Value
dependency dep =
  object
    [ ("type", string dep.deptype)
    , ("version", string dep.version)
    ]

version : Version -> Value
version v =
  object
    [ ("changes", string v.changes)
    , ("depends", object <| map (\d -> (d.name, dependency d)) v.depends)
    , ("files", object <| map (\f -> (f.url, file f)) v.files)
    ]

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
      , ("versions", object <| map (\v -> (v.version, version v)) pkg.versions )
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