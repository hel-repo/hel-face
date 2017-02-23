{-
  Hel Repository single-page web app client
  2016-2017 (c) MoonlightOwl
-}

import Navigation
import UrlParser as Url

import Models exposing (..)
import Base.Helpers.Tools exposing (batchMsg)
import Base.Messages exposing (Msg(..))
import Base.Ports exposing (load, doload)

import Routing exposing (Route(..))
import Update exposing (update)
import View exposing (view)


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
  let
    currentRoute = Maybe.withDefault NotFoundRoute <| Url.parseHash Routing.route location
  in
    ( initialModel currentRoute flags.logo )
    ! [ batchMsg <| CheckSession :: (Routing.routeMessage currentRoute), doload () ]

main : Program Flags Model Msg
main =
  Navigation.programWithFlags UpdateUrl
    { init = init
    , view = view
    , subscriptions = \model -> load StorageLoaded
    , update = update
    }
