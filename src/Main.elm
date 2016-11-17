{-
  Hel Repository single-page web app
  2016 (c) MoonlightOwl
-}

import Time exposing (every)

import Navigation

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Base.Tools exposing (batchMsg)

import User.Messages as UMsg

import Routing exposing (routeMessage, Route(..))
import Update exposing (update)
import View exposing (view)


init : Result String Route -> ( Model, Cmd Msg )
init result =
  let
    currentRoute =
      Routing.routeFromResult result
  in
    ( initialModel currentRoute
    , batchMsg <| (UserMsg UMsg.CheckSession) :: (routeMessage currentRoute)
    )


urlUpdate : Result String Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
  let
    currentRoute =
      Routing.routeFromResult result
  in
    ( { model | route = currentRoute }, batchMsg ( routeMessage currentRoute ) )


main : Program Never
main =
  Navigation.program Routing.parser
    { init = init
    , view = view
    , subscriptions = always <| every Config.tickDelay Tick
    , update = update
    , urlUpdate = urlUpdate
    }
