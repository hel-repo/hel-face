module Routing exposing (..)

import String
import Navigation
import UrlParser exposing (..)

import Base.Messages exposing (Msg(..))
import Package.Messages as PMsg
import Package.Models exposing (SearchData, searchAll, searchByName)
import User.Messages as UMsg


type Route
  = PackageListRoute SearchData
  | PackageRoute String
  | PackageEditRoute String
  | AuthRoute
  | RegisterRoute
  | ProfileRoute
  | NotFoundRoute


routeMessage : Route -> List Msg
routeMessage route =
  case route of
    PackageRoute name -> [ PackageMsg <| PMsg.GoToPackageDetails name ]
    PackageEditRoute name -> [ PackageMsg <| PMsg.GoToPackageEdit name ]
    PackageListRoute data -> [ PackageMsg <| PMsg.GoToPackageList data ]
    AuthRoute -> [ UserMsg <| UMsg.GoToAuth ]
    RegisterRoute -> [ UserMsg <| UMsg.GoToRegister ]
    _ -> []

tail : Parser a a
tail = s ""

matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ format (PackageListRoute searchAll) (tail)
    , format (PackageEditRoute "") (s "packages" </> s "edit" </> tail)
    , format PackageEditRoute (s "packages" </> s "edit" </> string)
    , format (PackageEditRoute "") (s "packages" </> s "edit")
    , format (PackageListRoute searchAll) (s "packages" </> tail)
    , format (PackageListRoute << searchByName) (s "search" </> string)
    , format PackageRoute (s "packages" </> string)
    , format (PackageListRoute searchAll) (s "packages")
    , format AuthRoute (s "auth")
    , format RegisterRoute (s "register")
    , format ProfileRoute (s "profile")
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