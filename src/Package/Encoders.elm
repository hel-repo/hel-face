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
    , ("depends", object <| map (\d -> (d.name, if d.remove then null else dependency d)) v.depends)
    , ("files", object <| map (\f -> (f.url, if f.remove then null else file f)) v.files)
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


resolvedFiles : Version -> Version -> Version
resolvedFiles v ov =
  let nullified = List.map ( \file -> { file | remove = True } )
    <| List.filter ( \oldFile -> List.all ( \file -> file.url /= oldFile.url ) v.files ) ov.files
  in { v | files = List.append nullified v.files }

resolvedDependencies : Version -> Version -> Version
resolvedDependencies v ov =
  let nullified = List.map ( \dep -> { dep | remove = True } )
    <| List.filter ( \oldDep -> List.all ( \dep -> dep.name /= oldDep.name ) v.depends ) ov.depends
  in { v | depends = List.append nullified v.depends }

getEquivalent : a -> List a -> (a -> a -> Bool) -> Maybe a
getEquivalent item list comparator =
  List.head <| List.filter ( \i -> comparator item i ) list

-- Nullify missing items and name field, to create valid 'patch' object
resolved : Package -> Package -> Package
resolved pkg oldPkg =
  let
    prepared = List.map
      ( \v ->
          case getEquivalent v oldPkg.versions (\a b -> a.version == b.version) of
            Just ov -> resolvedFiles ( resolvedDependencies v ov ) ov
            Nothing -> v
      )
      pkg.versions
    nullified = List.map ( \v -> { v | remove = True } )
      <| List.filter ( \ov -> List.all ( \v -> v.version /= ov.version ) pkg.versions ) oldPkg.versions
  in
    { pkg
      | versions = List.append nullified prepared
      , name = if pkg.name /= oldPkg.name then pkg.name else ""
    }


packageEncoder : Package -> Package -> String
packageEncoder pkg oldPkg =
  encode 0 <| package <| resolved pkg oldPkg