{-
  Hel Repository single-page web app
  2016 (c) MoonlightOwl
-}

import Html.App as App
import Task exposing (Task)

import Material

import Messages exposing (Msg(..))
import Models exposing (..)
import View exposing (view)
import Update exposing (update)


main : Program Never
main =
  App.program
    { init = ( model, Task.perform (always FetchPackages) (always FetchPackages) (Task.succeed ()) )
    , view = view
    , subscriptions = always Sub.none
    , update = update
    }
