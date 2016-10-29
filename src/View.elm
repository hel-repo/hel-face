module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Material
import Material.Layout as Layout
import Material.Options as Options exposing (cs)

import Base.Messages exposing (Msg(..))
import Base.Models exposing (..)
import Package.List
import Package.Details
import Routing exposing (routeMessage, Route(..))


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader
    , Layout.waterfall True
    ]
    { header =
      [ div
        [ class "header"
        , onClick (RoutePackageList)
        ]
        [ h1 [] [ text "HEL Repository" ]
        , div [ class "error" ] [ text model.list.error ]
        ]
      ]
    , drawer = []
    , tabs = ( [], [] )
    , main = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
  case model.route of
    PackageListRoute ->
      Package.List.view model.list

    PackageRoute name ->
      Package.Details.view model.list

    NotFoundRoute ->
      text "404: Page Not Found"
