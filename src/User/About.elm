module User.About exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, src)

import Material.Card as Card
import Material.Elevation as Elevation
import Material.Grid exposing (..)

import Base.Config as Config
import Base.Messages exposing (Msg(..))
import User.Models exposing (UserData)


about : UserData -> Html Msg
about data =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ] [ Card.head [] [ text "About us" ] ]
    , Card.text []
      [ div []
          [ img [ src "static/media/about.6c5ea71c.png" ] [] ]
      , div [ class "about-title" ] [ text "HEL Package Repository" ]
      , hr [] []
      , div
          [ class "about-description" ]
          [ div [] [ text "Easy way to distribute your application." ]
          , div [] [ text <| "You don't need to worry about necessary libraries,"
                          ++ " where your application was put by user, which name your files got,"
                          ++ " or how to download all the parts and not to forget anything." ]
          ]
      , hr [] []
      , div []
          [ text "IRC channel:"
          , span [ class "about-value" ] [ a [ href "https://webchat.esper.net/?channels=#cc.ru" ] [ text "#cc.ru" ] ]
          ]
      , div []
          [ text "GitHub:"
          , span [ class "about-value" ] [ a [ href "https://github.com/hel-repo" ] [ text "hel-repo" ] ]
          ]
      , hr [] []
      , div []
        [ text "Version / API:"
        , span [ class "about-value" ] [ text <| Config.version ++ " / " ++ data.apiVersion ]
        ]
      , div [ class "about-copyright" ] [ text "2016 (c) Fingercomp, Totoro" ]
      ]
    ]


view : UserData -> Html Msg
view data =
  div
    [ class "page auth-card" ]
    [ grid []
        [ cell [ size All 3, size Tablet 0 ] [ ]
        , cell [ size All 6, size Tablet 8 ] [ about data ]
        , cell [ size All 3, size Tablet 0 ] [ ]
        ]
    ]