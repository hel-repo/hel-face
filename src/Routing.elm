module Routing exposing (..)

import Http exposing (decodeUri)
import UrlParser exposing (..)

import Base.Messages exposing (Msg(..))
import Base.Search exposing (SearchData, searchAll, searchData)
import Package.Messages as PMsg
import User.Messages as UMsg


type Route
  = PackageListRoute SearchData
  | PackageRoute String
  | PackageEditRoute String
  | AuthRoute
  | RegisterRoute
  | ProfileRoute
  | AboutRoute
  | NotFoundRoute


routeMessage : Route -> List Msg
routeMessage route =
  case route of
    PackageRoute name -> [ PackageMsg <| PMsg.GoToPackageDetails name ]
    PackageEditRoute name -> [ PackageMsg <| PMsg.GoToPackageEdit name ]
    PackageListRoute data -> [ PackageMsg <| PMsg.GoToPackageList data ]
    AuthRoute -> [ UserMsg <| UMsg.GoToAuth ]
    RegisterRoute -> [ UserMsg <| UMsg.GoToRegister ]
    ProfileRoute -> [ UserMsg <| UMsg.GoToProfile ]
    AboutRoute -> [ UserMsg <| UMsg.GoToAbout ]
    _ -> []

route : Parser (Route -> a) a
route =
  oneOf
    [ map (PackageListRoute searchAll) top
    , map (PackageListRoute searchAll) (s "search")
    , map (PackageListRoute << searchData << (Maybe.withDefault "" << decodeUri)) (s "search" </> string)
    , map (PackageListRoute searchAll) (s "packages")
    , map PackageRoute (s "packages" </> string)
    , map (PackageEditRoute "") (s "edit")
    , map PackageEditRoute (s "edit" </> string)
    , map AuthRoute (s "auth")
    , map RegisterRoute (s "register")
    , map ProfileRoute (s "profile")
    , map AboutRoute (s "about")
    ]
