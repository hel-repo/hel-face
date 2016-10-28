module Package.Details exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
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

license : String -> Html Msg
license name =
  case name of
    "MIT" ->
      a [ href "http://choosealicense.com/licenses/mit/" ] [ text name ]
    "Apache 2.0" ->
      a [ href "http://choosealicense.com/licenses/apache-2.0/" ] [ text name ]
    "BSD" ->
      a [ href "http://choosealicense.com/licenses/bsd-2-clause/" ] [ text name ]
    name ->
      text name

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
            [ Card.title [ ]
              [ Card.head [ white ] [ text package.name ]
              , Card.subhead [ ]
                [ text ("by " ++ ( join ", " package.authors ))
                , span [ class "card-license" ] [ text "© " ]
                , span [ ] [ license package.license ]
                ]
              ]
            , Card.text [ white ] [ Markdown.toHtml [] package.description ]
            , Card.menu [ ] ( map chip package.tags )
            ]
          ]
      Nothing ->
        text "404: Package not found!"
