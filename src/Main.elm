{-
  Hel Repository single-page web app
  2016 (c) MoonlightOwl
-}

import Html.App as App
import Task exposing (Task)

import Messages exposing (Msg(..))
import Models exposing (..)
import View exposing (view)
import Update exposing (update)
import Package.Messages as PMsg


main : Program Never
main =
  App.program
    { init =
      ( initialModel
      , Task.perform
          (always ( PackageMsg PMsg.FetchPackages ))
          (always ( PackageMsg PMsg.FetchPackages ))
          (Task.succeed())
      )
    , view = view
    , subscriptions = always Sub.none
    , update = update
    }
