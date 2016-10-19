module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)

import Material
import Material.Layout as Layout
import Material.Spinner as Loading
import Material.Options as Options exposing (cs)

import Messages exposing (Msg(..))
import Models exposing (..)
import Package.List as Package


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader
    , Layout.onSelectTab SelectTab
    , Layout.selectedTab model.selectedTab
    , Layout.waterfall True
    ]
    { header = [ div [ class "header" ] [ h1 [] [ text "HEL Repository" ] ] ]
    , drawer = []
    , tabs = ( [ text "New", text "Popular", text "All" ], [] )
    , main = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
  if model.loading then
    Loading.spinner
      [ Loading.active True
      , cs "spinner"
      ]
  else case model.selectedTab of
    0 ->
      Package.list model.packages
    1 ->
      text "Popular"
    2 ->
      text "All"
    _ ->
      text "404"