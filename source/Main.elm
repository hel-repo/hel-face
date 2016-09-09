module Main exposing (..)

import Html exposing (div, span, strong, text)
import Html.App

import List exposing (length)

import Ui.Container
import Ui.Button
import Ui.App
import Ui


-- MODEL

type alias Model =
  { app : Ui.App.Model
  , packages : List Package
  }


type alias Package =
    { name : String
    , description : String
    , owner : String
    , authors : List String
    , tags : List String
    }


-- UPDATE

type Msg
  = App Ui.App.Msg
  | LoadPackages

init : Model
init =
  { app = Ui.App.init
  , packages = []
  }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    App act ->
      let
        ( app, effect ) =
          Ui.App.update act model.app
      in
        ( { model | app = app }, Cmd.map App effect )

    LoadPackages ->
      ( model, Cmd.none )


-- RENDER

view : Model -> Html.Html Msg
view model =
  Ui.App.view
    App
    model.app
    [ Ui.Container.column
        []
        [ Ui.title [] [ text "HEL Repository" ]
        , div
            []
            [ text "Packages total: "
            , strong [] [ text (toString (length model.packages)) ] ]
        ]
    ]


main =
  Html.App.program
    { init = ( init, Cmd.none )
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
