{-
  Hel Repository single-page web app client
  2016 (c) MoonlightOwl
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


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
  let
    currentRoute = Maybe.withDefault NotFoundRoute <| Url.parseHash Routing.route location
  in
    ( initialModel currentRoute
    , batchMsg <| CheckSession :: (Routing.routeMessage currentRoute)
    )

main : Program Never Model Msg
main =
  Navigation.program UpdateUrl
    { init = init
    , view = view
    , subscriptions = always <| every Config.tickDelay Tick
    , update = update
    }
