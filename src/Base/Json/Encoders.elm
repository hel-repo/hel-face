module Base.Json.Encoders exposing (..)

import Array
import Json.Encode as Json exposing (..)

import Base.Models.Package exposing (Package, Screenshot, Version, VersionDependency, VersionFile)
import Base.Models.User exposing (User)


-- User related encoding
------------------------------------------------------------------------------------------------------------------------
userEncoder : User -> String -> String
userEncoder user oldNickname =
  encode 0 <| object <|
    List.concat
      [ ( if user.nickname == oldNickname then
            []
          else
            [ ("nickname", string user.nickname) ]
        )
      , [ ("groups", list <| List.map string user.groups) ]
      , ( if String.isEmpty user.password then
            []
          else
            [ ("password", string user.password) ]
        )
      ]


-- Package related encoding
------------------------------------------------------------------------------------------------------------------------
file : VersionFile -> Value
file f =
  object
    [ ("dir", string f.dir)
    , ("name", string f.name)
    ]

dependency : VersionDependency -> Value
dependency dep =
  object
    [ ("type", string dep.deptype)
    , ("version", string dep.version)
    ]

version : Version -> Value
version v =
  object
    [ ("changes", string v.changes)
    , ("depends", object <| List.map (\d -> (d.name, if d.remove then null else dependency d)) v.depends)
    , ("files", object <| List.map (\f -> (f.url, if f.remove then null else file f)) v.files)
    ]

package : Package -> Value
package pkg =
  let
    fields =
      [ ("license", string pkg.license)
      , ("description", string pkg.description)
      , ("short_description", string pkg.shortDescription)
      , ("owners", array <| Array.fromList <| List.map string pkg.owners)
      , ("authors", array <| Array.fromList <| List.map string pkg.authors)
      , ("tags", array <| Array.fromList <| List.map string pkg.tags)
      , ("versions", object <| List.map (\v -> (v.version, if v.remove then null else version v)) pkg.versions)
      , ("screenshots",
           object <| List.map (\s -> (s.url, if s.remove then null else string s.description)) pkg.screenshots)
      ]
  in
    object
      ( if not <| String.isEmpty pkg.name then
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

resolvedScreenshots : Package -> Package -> List Screenshot
resolvedScreenshots p op =
  let nullified = List.map ( \screen -> { screen | remove = True } )
    <| List.filter ( \oldScreen -> List.all ( \screen -> screen.url /= oldScreen.url ) p.screenshots ) op.screenshots
  in List.append nullified p.screenshots

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
      , screenshots = resolvedScreenshots pkg oldPkg
    }

packageEncoder : Package -> Package -> String
packageEncoder pkg oldPkg =
  encode 0 <| package <| resolved pkg oldPkg
