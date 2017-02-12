module About exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, src)

import Material.Card as Card
import Material.Elevation as Elevation
import Material.Grid exposing (..)

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models.User exposing (Session)


about : Session -> Html Msg
about session =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ] [ Card.head [] [ text "About us" ] ]
    , Card.text []
      [ div []
          [ img [ src "static/media/about.6c5ea71c.png" ] [] ]
      , p [ class "about-title" ] [ text "HEL Package Repository" ]
      , div
          [ class "about-description" ]
          [ div [] [ text "An easy way to distribute your applications." ] ]
      , p [] []
      , div []
          [ text "IRC channel:"
          , span [ class "about-value" ] [ a [ href "https://webchat.esper.net/?channels=#cc.ru" ] [ text "#cc.ru" ] ]
          ]
      , div []
          [ text "GitHub:"
          , span [ class "about-value" ] [ a [ href "https://github.com/hel-repo" ] [ text "hel-repo" ] ]
          ]
      , p [] []
      , div []
        [ text "Version / API:"
        , span [ class "about-value" ] [ text <| Config.version ++ " / " ++ session.apiVersion ]
        ]
      , div [ class "about-copyright" ] [ text "2017 (c) Fingercomp, Totoro" ]
      ]
    ]


view : Session -> Html Msg
view session =
  div
    [ class "page auth-card" ]
    [ grid []
        [ cell [ size All 3, size Tablet 0 ] [ ]
        , cell [ size All 6, size Tablet 8 ] [ about session ]
        , cell [ size All 3, size Tablet 0 ] [ ]
        ]
    ]
