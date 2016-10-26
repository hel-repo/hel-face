module Package.Details exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import List exposing (head, map)
import String exposing (join)

import Markdown

import Material.Card as Card
import Material.Chip as Chip
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading

import Base.Messages exposing (Msg(..))
import Package.Models exposing (PackageListData)


white : Options.Property c m
white =
  Color.text Color.white

chip : String -> Html Msg
chip str =
  Chip.span [] [ Chip.content [] [ text str ] ]

view : PackageListData -> Html Msg
view data =
  if data.loading then
    Loading.spinner
      [ Loading.active True
      , cs "spinner"
      ]
  else
    case head data.packages of
      Just package ->
        div
          [ class "page" ]
          [ Card.view
            [ Elevation.e2 ]
            [ Card.title
              [ ]
              [ Card.head [ white ] [ text package.name ]
              , Card.subhead [ ] [ text ("by " ++ ( join ", " package.authors )) ]
              ]
              , Card.text [ white ] [ Markdown.toHtml [] package.description ]
              , Card.menu [ ] ( map chip package.tags )
            ]
          ]
      Nothing ->
        text "404: Package not found!"
