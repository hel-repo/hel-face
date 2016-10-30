module Routing exposing (..)

import String
import Navigation
import UrlParser exposing (..)

import Base.Messages exposing (Msg(..))
import Package.Messages as PMsg
import Package.Models exposing (SearchData, searchAll, searchByName)


type Route
  = PackageListRoute SearchData
  | PackageRoute String
  | NotFoundRoute


routeMessage : Route -> List Msg
routeMessage route =
  case route of
    PackageRoute name -> [ PackageMsg <| PMsg.GoToPackageDetails name ]
    PackageListRoute data -> [ PackageMsg <| PMsg.GoToPackageList data ]
    NotFoundRoute -> []


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ format (PackageListRoute searchAll) (s "")
    , format (PackageListRoute << searchByName) (s "search" </> string)
    , format (PackageListRoute searchAll) (s "packages" </> s "")
    , format PackageRoute (s "packages" </> string)
    , format (PackageListRoute searchAll) (s "packages")
    ]


hashParser : Navigation.Location -> Result String Route
hashParser location =
  location.hash
    |> String.dropLeft 1
    |> parse identity matchers


parser : Navigation.Parser (Result String Route)
parser =
  Navigation.makeParser hashParser


routeFromResult : Result String Route -> Route
routeFromResult result =
  case result of
    Ok route ->
      route

    Err string ->
      NotFoundRoute