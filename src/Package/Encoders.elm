module Package.Encoders exposing (packageEncoder)

import Array exposing (fromList)
import Json.Encode as Json exposing (..)
import List exposing (map)
import String exposing (isEmpty)

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
      , ("versions", object <| map (\v -> (v.version, if v.remove then null else version v)) pkg.versions)
      , ("screenshots", object <| map (\s -> (s.url, string s.description)) pkg.screenshots)
      ]
  in
    object
      ( if not <| isEmpty pkg.name then
          ("name", string pkg.name) :: fields
        else
          fields
      )


-- Nullify missing items and name field, to create valid 'patch' object
resolved : Package -> Package -> Package
resolved pkg oldPkg =
  let
    nullified = List.map ( \v -> { v | remove = True } )
      <| List.filter ( \ov -> List.all ( \v -> v.version /= ov.version ) pkg.versions ) oldPkg.versions
  in
    { pkg
      | versions = List.append nullified pkg.versions
      , name = if pkg.name /= oldPkg.name then pkg.name else ""
    }


packageEncoder : Package -> Package -> String
packageEncoder pkg oldPkg =
  encode 0 <| package <| resolved pkg oldPkg