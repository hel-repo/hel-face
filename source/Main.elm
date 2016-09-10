module Main exposing (..)

import Html exposing (div, span, strong, text)
import Html.App

import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)

import List exposing (length, map)

import Ui.Container
import Ui.Button
import Ui.App
import Ui


-- MODEL

type alias Model =
  { app : Ui.App.Model
  , error : String
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
  | FetchPackages
  | ErrorOccurred String
  | PackagesFetched (List Package)


packagesDecoder : Json.Decoder (List Package)
packagesDecoder =
  let package =
    Json.object5 Package
        ("name" := Json.string)
        ("description" := Json.string)
        ("owner" := Json.string)
        ("authors" := Json.list Json.string)
        ("tags" := Json.list Json.string)
  in
    Json.list package

lookupPackages : Cmd Msg
lookupPackages =
  Http.get packagesDecoder "http://hel-roottree.rhcloud.com/packages"
    |> Task.mapError toString
    |> Task.perform ErrorOccurred PackagesFetched


init : Model
init =
  { app = Ui.App.init
  , error = ""
  , packages = []
  }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    App act ->
      let
        ( app, eff ) =
          Ui.App.update act model.app
      in
        ( { model | app = app }, Cmd.map App eff )

    FetchPackages ->
      model ! [lookupPackages]

    ErrorOccurred message ->
      { model | error = message } ! []

    PackagesFetched packages ->
      { model | packages = packages } ! []



-- RENDER

view : Model -> Html.Html Msg
view model =
  let
    showPackage package = div [] [ text package.name ]
  in
    Ui.App.view
      App
      model.app
      [ Ui.Container.column []
          [ Ui.title [] [ text "HEL Repository" ]
          , text model.error
          , Ui.Container.row [] [ Ui.Button.success "Update" FetchPackages ]
          , div []
              [ div [] (map showPackage model.packages)
              , text "Packages total: "
              , strong [] [ text (toString (length model.packages)) ]
              ]
          ]
      ]


main =
  Html.App.program
    { init = ( init, Cmd.none )
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
