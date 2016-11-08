module Package.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)

import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading

import Base.Messages exposing (Msg(..))
import Package.Models exposing (PackageData)


white : Options.Property c m
white =
  Color.text Color.white

view : PackageData -> Html Msg
view data =
  if data.loading then
    Loading.spinner
      [ Loading.active True
      , cs "spinner"
      ]
  else
    div
      [ class "page" ]
      [ Card.view
          [ Elevation.e2 ]
          [ Card.title [ ] [ Card.head [ white ] [ text "Edit package" ] ]
          , Card.text [ white ] [ div [ ] [ text "Let's see..." ] ]
          ]
      ]