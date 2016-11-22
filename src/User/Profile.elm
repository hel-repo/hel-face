module User.Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import List

import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import Base.Models exposing (Package)
import Base.Url as Url
import Package.Messages as PMsg
import User.Models exposing (UserData)


badge : String -> Html Msg
badge group =
  Chip.button
    [ cs (if group == "admins" then "admin-badge" else "user-badge" ) ]
    [ Chip.content []
        [ text group ]
    ]

subtitle : String -> Html Msg
subtitle str =
  Options.styled p [ Typo.button, cs "subtitle" ] [ text str ]

profile : UserData -> Html Msg
profile data =
  Card.view
    [ Elevation.e3 ]
    [ Card.title [ Card.border ] [ Card.head [] [ text "Profile" ] ]
    , Card.text [ cs "profile-panel" ]
      [ div [ class "profile-avatar" ] [ Icon.view "account_circle" [ cs "avatar" ] ]
      , div [ class "profile-info" ]
          [ subtitle "Nickname"
          , div
              [ class "profile-nickname" ]
              [ text data.session.user.nickname ]
          , subtitle "Groups"
          , div
              [ class "profile-badges" ]
              ( List.map
                  badge
                  (if List.isEmpty data.session.user.groups then ["user"] else data.session.user.groups)
              )
          ]
      ]
    ]


card : UserData -> Int -> Package -> Cell Msg
card data index package =
  cell
    [ size All 6, size Tablet 8 ]
    [ Card.view
        [ ]
        [ Card.title
          [ cs "card-title" ]
          [ Card.head [] [ a [ href <| Url.package package.name ] [ text package.name ] ] ]
        , Card.menu
            [ cs "noselect list-card-menu-button" ]
            [ Menu.render Mdl [index*3] data.mdl
                [ Menu.ripple, Menu.bottomRight ]
                [ Menu.item
                    [ Menu.onSelect <| RoutePackageEdit package.name ]
                    [ Icon.view "mode_edit" [ cs "menu-icon" ], text "Edit" ]
                , Menu.item
                    [ Menu.onSelect <| PackageMsg (PMsg.RemovePackage package.name) ]
                    [ Icon.view "delete" [ cs "menu-icon danger" ], text "Delete" ]
                ]
            ]
        , Card.text [] [ text package.shortDescription ]
        ]
    ]

noPackages : Html Msg
noPackages =
  Card.view
    [ ]
    [ Card.title [] [ Card.head [] [ text "Nothing found!" ] ]
    , Card.text []
        [ div [] [ text "You've not added any packages to this repository yet." ] ]
    ]

packages : UserData -> Html Msg
packages data =
  Card.view
    [ Elevation.e2
    , cs "profile-packages"
    ]
    [ Card.title [ Card.border ] [ Card.head [] [ text "My packages" ] ]
    , Card.actions
        [ cs "profile-packages-container" ]
        [ if List.isEmpty data.packages then div [ class "page" ] [ noPackages ]
          else grid [] <| List.map2 (card data) (List.range 1 <| List.length data.packages) data.packages
        ]
    ]


view : UserData -> Html Msg
view data =
  if data.loading then
    Loading.spinner
      [ Loading.active True
      , cs "spinner"
      ]
  else
    div
      [ class "page" ]
      [ grid [ ]
          [ cell [ size All 2, size Tablet 0 ] [ ]
          , cell [ size All 8, size Tablet 8 ] [ profile data, packages data ]
          , cell [ size All 2, size Tablet 0 ] [ ]
          ]
      ]
