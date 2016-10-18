{-
  Hel Repository single-page web app
  2016 (c) MoonlightOwl
-}

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (href, class, style)

import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)

import List exposing (length, map)

import Material
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Spinner as Loading
import Material.Options as Options exposing (cs, css)


-- MODEL

type alias Package =
  { name : String
  , description : String
  , short_description : String
  , owners : List String
  , authors : List String
  , tags : List String
  }

type alias Model =
  { mdl : Material.Model
  , selectedTab : Int
  , loading : Bool
  , error : String
  , packages : List Package
  }


model : Model
model =
  { mdl = Material.model
  , selectedTab = 0
  , loading = False
  , error = ""
  , packages = []
  }


-- ACTION, UPDATE

type Msg
  = Mdl (Material.Msg Msg)
  | SelectTab Int
  | FetchPackages
  | ErrorOccurred String
  | PackagesFetched (List Package)


packagesDecoder : Json.Decoder (List Package)
packagesDecoder =
  let package =
    Json.object6 Package
        ("name" := Json.string)
        ("description" := Json.string)
        ("short_description" := Json.string)
        ("owners" := Json.list Json.string)
        ("authors" := Json.list Json.string)
        ("tags" := Json.list Json.string)
  in
    Json.at ["data"] ( Json.list package )

lookupPackages : Cmd Msg
lookupPackages =
  Http.get packagesDecoder "http://hel-roottree.rhcloud.com/packages"
    |> Task.mapError toString
    |> Task.perform ErrorOccurred PackagesFetched


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Mdl msg' ->
      Material.update msg' model

    SelectTab num ->
      let
        newModel = { model | selectedTab = num }
      in
        if num == 0 then
          update FetchPackages newModel
        else
          newModel ! []

    FetchPackages ->
      { model | loading = True } ! [lookupPackages]

    ErrorOccurred message ->
      { model | error = message, loading = False } ! []

    PackagesFetched packages ->
      { model | packages = packages, loading = False } ! []


-- VIEW

type alias Mdl =
  Material.Model


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader
    , Layout.onSelectTab SelectTab
    , Layout.selectedTab model.selectedTab
    ]
    { header = [ h1 [style [ ( "padding", "2rem" ) ] ] [ text "HEL Repository" ] ]
    , drawer = []
    , tabs = ( [ text "New", text "Popular", text "All" ], [ Color.background (Color.color Color.BlueGrey Color.S400) ] )
    , main = [ viewBody model ]
    }


white : Options.Property c m
white =
  Color.text Color.white

viewPackage : Package -> Cell Msg
viewPackage package =
  cell [ size All 4 ]
    [ Card.view
        [ Color.background (Color.color Color.BlueGrey Color.S400)
        , Elevation.e2
        ]
        [ Card.title [ ] [ Card.head [ white ] [ text package.name ] ]
        , Card.text [ white ] [ text package.short_description ]
        , Card.actions
            [ Card.border, css "vertical-align" "center", css "text-align" "right", white ]
            [ Button.render Mdl [8,1] model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [0,0] model.mdl
                [ Button.icon, Button.ripple, white ]
                [ Icon.i "share" ]
            ]
        ]
    ]


viewBody : Model -> Html Msg
viewBody model =
  if model.loading then
    Loading.spinner
      [ Loading.active True
      , css "position" "absolute"
      , css "top" "0"
      , css "bottom" "0"
      , css "left" "0"
      , css "right" "0"
      , css "margin" "auto"
      ]
  else case model.selectedTab of
    0 ->
      div
        [ style [ ( "padding", "2rem" ) ] ]
        [ grid [] ( map viewPackage model.packages )
        ]
    1 ->
      text "Popular"
    2 ->
      text "All"
    _ ->
      text "404"


main : Program Never
main =
  App.program
    { init = ( model, Task.perform (always FetchPackages) (always FetchPackages) (Task.succeed ()) )
    , view = view
    , subscriptions = always Sub.none
    , update = update
    }
