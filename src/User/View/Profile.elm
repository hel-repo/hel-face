module User.View.Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import List

import Material.Button as Button
import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Grid exposing (..)
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css)
import Material.Spinner as Loading
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import Base.Models.Package exposing (Package)
import Base.Network.Url as Url
import Package.Messages as PMsg
import User.Localization as L
import User.Messages as UMsg
import User.Models exposing (UserData)


badge : String -> Html Msg
badge group =
  Chip.button
    [ Options.onClick <| Navigate <| Url.usersByGroup group
    , cs (if group == "admins" then "admin-badge" else "user-badge" )
    ]
    [ Chip.content [] [ text group ] ]

subtitle : String -> Html Msg
subtitle str =
  Options.styled p [ Typo.button, cs "subtitle" ] [ text str ]

checkmark: Bool -> Html Msg
checkmark x =
    if x then
      Icon.view "check" [ cs "menu-icon" ]
    else
      Options.span [ cs "menu-icon" ] []


profile : UserData -> Html Msg
profile data =
  Card.view
    [ Elevation.e3
    , css "z-index" <| toString 10
    ]
    [ Card.title [ Card.border ] [ Card.head [] [ text (L.get data.session.lang L.profile) ] ]
    , Card.menu [ cs "noselect" ]
        ( if List.member "admins" data.session.user.groups then
            [ Menu.render Mdl [20] data.mdl
                [ Menu.ripple, Menu.bottomRight ]
                [ Menu.item
                    []
                    [ checkmark (data.session.lang == "en"), text "English" ]
                , Menu.item
                    [ Menu.divider ]
                    [ checkmark (data.session.lang == "ru"), text "Русский" ]
                , Menu.item
                    [ Menu.onSelect <| Navigate <| Url.editUser data.user.nickname ]
                    [ Icon.view "mode_edit" [ cs "menu-icon" ], text (L.get data.session.lang L.edit) ]
                , Menu.item
                    [ Menu.onSelect <| UserMsg <| UMsg.RemoveUser data.user.nickname ]
                    [ Icon.view "delete" [ cs "menu-icon danger" ], text (L.get data.session.lang L.delete) ]
                ]
            ]
          else []
        )
    , Card.text [ cs "profile-panel" ]
      [ div [ class "profile-avatar" ] [ Icon.view "account_circle" [ cs "avatar" ] ]
      , div [ class "profile-info" ]
          [ subtitle (L.get data.session.lang L.nickname)
          , div
              [ class "profile-nickname" ]
              [ text data.user.nickname ]
          , subtitle (L.get data.session.lang L.groups)
          , div
              [ class "profile-badges" ]
              ( List.map
                  badge
                  (if List.isEmpty data.user.groups then ["user"] else data.user.groups)
              )
          ]
      ]
    ]


package : UserData -> Int -> Package -> Cell Msg
package data index package =
  cell
    [ size All 6, size Tablet 8 ]
    [ Card.view
        [ css "z-index" <| toString <| 100-index ]
        [ Card.title
          [ cs "card-title" ]
          [ Card.head [] [ a [ href <| Url.package package.name ] [ text package.name ] ] ]
        , Card.menu
            [ cs "noselect list-card-menu-button" ]
            [ Menu.render Mdl [index*3] data.mdl
                [ Menu.ripple, Menu.bottomRight ]
                [ Menu.item
                    [ Menu.onSelect <| RoutePackageEdit package.name ]
                    [ Icon.view "mode_edit" [ cs "menu-icon" ], text (L.get data.session.lang L.edit) ]
                , Menu.item
                    [ Menu.onSelect <| PackageMsg (PMsg.RemovePackage package.name) ]
                    [ Icon.view "delete" [ cs "menu-icon danger" ], text (L.get data.session.lang L.delete) ]
                ]
            ]
        , Card.text [] [ text package.shortDescription ]
        ]
    ]

noPackages : UserData -> Html Msg
noPackages data =
  Card.view
    [ ]
    [ Card.title [] [ Card.head [] [ text (L.get data.session.lang L.nothingFound) ] ]
    , Card.text []
        [ div []
            [ text
                ( if data.user.nickname == data.session.user.nickname then
                    (L.get data.session.lang L.youHaveNotAddedAnything)
                  else
                    (L.get data.session.lang L.thisUserHaveNotAddedAnything)
                )
            ]
        ]
    ]

appboard : UserData -> Html Msg
appboard data =
  if List.member "admins" data.session.user.groups then
    Card.view
      [ Elevation.e2
      , cs "profile-packages"
      ]
      [ Card.title [ Card.border ] [ Card.head [] [ text (L.get data.session.lang L.dashboard) ] ]
      , Card.actions
          [ ]
          [ Button.render Mdl [100] data.mdl
              [ Button.raised
              , Button.ripple
              , Options.onClick <| Navigate Url.users
              ]
              [ text (L.get data.session.lang L.allUsers) ]
          , Button.render Mdl [101] data.mdl
              [ Button.raised
              , Button.ripple
              , Options.onClick <| Navigate <| Url.usersByGroup "admins"
              , cs "appboard-button"
              ]
              [ text (L.get data.session.lang L.admins) ]
          , Button.render Mdl [102] data.mdl
              [ Button.raised
              , Button.ripple
              , Options.onClick <| Navigate <| Url.usersByGroup "banned"
              , cs "appboard-button"
              ]
              [ text (L.get data.session.lang L.banlist) ]
          ]
      ]
  else
    div [] []

packages : UserData -> Html Msg
packages data =
  Card.view
    [ Elevation.e2
    , cs "profile-packages"
    ]
    [ Card.title
        [ Card.border ]
        [ Card.head []
            [ text <|
                if data.user.nickname == data.session.user.nickname then
                  (L.get data.session.lang L.myPackages)
                else
                  (L.get data.session.lang L.packages)
            ]
        ]
    , Card.actions
        [ cs "profile-packages-container" ]
        [ if List.isEmpty data.packages.list then div [ class "page" ] [ noPackages data ]
          else grid [] <| List.map2 (package data) (List.range 1 <| List.length data.packages.list) data.packages.list
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
          , cell [ size All 8, size Tablet 8 ] [ profile data, appboard data, packages data ]
          , cell [ size All 2, size Tablet 0 ] [ ]
          ]
      ]
