module Package.Details exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import List exposing (head)
import String exposing (join)

import Material.Card as Card
import Material.Color as Color
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading

import Base.Messages exposing (Msg(..))
import Package.Models exposing (PackageListData)


white : Options.Property c m
white =
  Color.text Color.white

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
           [ ]
           [ Card.title
             [ cs "card-title" ]
             [ Card.head [ white ] [ text package.name ]
             , Card.subhead [ ] [ text ("by " ++ ( join ", " package.authors )) ]
             ]
           , Card.text [ white ] [ text package.description ]
           ]
         ]
      Nothing ->
       text "404: Package not found!"
