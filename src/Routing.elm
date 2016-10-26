module Routing exposing (..)

import String
import Navigation
import UrlParser exposing (..)

import Base.Messages exposing (Msg(..))
import Package.Messages as PMsg


type Route
  = PackageListRoute
  | PackageRoute String
  | NotFoundRoute


routeMessage : Route -> List Msg
routeMessage route =
  case route of
    PackageRoute name -> [ PackageMsg (PMsg.GoToPackageDetails name) ]
    PackageListRoute -> [ PackageMsg PMsg.GoToPackageList ]
    NotFoundRoute -> []


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ format PackageListRoute (s "")
    , format PackageRoute (s "packages" </> string)
    , format PackageListRoute (s "packages")
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