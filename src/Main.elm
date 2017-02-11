{-
  Hel Repository single-page web app client
  2016-2017 (c) MoonlightOwl
-}

import Navigation
import UrlParser as Url
import Time exposing (every)

import Models exposing (..)
import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Tools exposing (batchMsg)

import Routing exposing (Route(..))
import Update exposing (update)
import View exposing (view)


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
  let
    currentRoute = Maybe.withDefault NotFoundRoute <| Url.parseHash Routing.route location
  in
    ( initialModel currentRoute flags.logo
    , batchMsg <| CheckSession :: (Routing.routeMessage currentRoute)
    )

main : Program Flags Model Msg
main =
  Navigation.programWithFlags UpdateUrl
    { init = init
    , view = view
    , subscriptions = always <| every Config.tickDelay Tick
    , update = update
    }
