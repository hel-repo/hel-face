module Routing exposing (..)

import Http exposing (decodeUri)
import UrlParser exposing (..)

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models.Network exposing (firstPage, customPage)
import Base.Helpers.Search exposing (PackagePage, queryPkgAll, queryPkgByName, phraseToPackageQuery)
import Package.Messages as PMsg
import User.Messages as UMsg


type Route
  = PackageListRoute PackagePage
  | PackageRoute String
  | PackageEditRoute String
  | AuthRoute
  | RegisterRoute
  | ProfileRoute String
  | UserListRoute String
  | UserEditRoute String
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
    ProfileRoute nickname -> [ UserMsg <| UMsg.GoToProfile nickname ]
    UserListRoute group -> [ UserMsg <| UMsg.GoToUserList group ]
    UserEditRoute nickname -> [ UserMsg <| UMsg.GoToUserEdit nickname ]
    AboutRoute -> [ UserMsg <| UMsg.GoToAbout ]
    _ -> []

parsePackages : Maybe String -> Maybe Int -> Route
parsePackages mQuery mPage =
  let
    offset = (Maybe.withDefault 0 mPage) * Config.pageSize
    phrase = Maybe.withDefault "" <| decodeUri <| Maybe.withDefault "" mQuery
    query = phraseToPackageQuery phrase
  in
    PackageListRoute <| customPage offset query

route : Parser (Route -> a) a
route =
  oneOf
    [ map parsePackages (top <?> stringParam "search" <?> intParam "page")
    , map (PackageListRoute <| firstPage queryPkgAll) top
    , map parsePackages (s "packages" <?> stringParam "search" <?> intParam "page")
    , map (PackageListRoute <| firstPage queryPkgAll) (s "packages")
    , map PackageRoute (s "packages" </> string)
    , map (PackageEditRoute "") (s "edit")
    , map PackageEditRoute (s "edit" </> string)
    , map (ProfileRoute "") (s "profile")
    , map ProfileRoute (s "profile" </> string)
    , map ProfileRoute (s "user" </> string)
    , map (UserListRoute "") (s "users")
    , map UserListRoute (s "users" </> string)
    , map (UserEditRoute "") (s "uedit")
    , map UserEditRoute (s "uedit" </> string)
    , map AuthRoute (s "auth")
    , map RegisterRoute (s "register")
    , map AboutRoute (s "about")
    ]
