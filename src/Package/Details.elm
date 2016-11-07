module Package.Details exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import List exposing (head, isEmpty, map, reverse, sortBy)
import String exposing (join)

import Markdown

import Material
import Material.Button as Button
import Material.Card as Card
import Material.Chip as Chip
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Grid as Grid
import Material.Icon as Icon
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css)
import Material.Spinner as Loading
import Material.Tabs as Tabs
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import Package.Messages as PMsg
import Package.Models exposing
  ( PackageData
  , Package, Version, PkgVersionFile, PkgVersionDependency
  )
import Base.Tools exposing ((!!))


white : Options.Property c m
white =
  Color.text Color.white


screensCard : Material.Model -> Package -> Html Msg
screensCard mdl package =
  if not (isEmpty package.screenshots) then
    case head package.screenshots of
      Just screen ->
        Card.view
          [ Elevation.e2, cs "screen-card" ]
          [ Card.actions
              [ cs "screen-img" ]
              [ img [ src screen.url ] [ ] ]
          , Card.actions
              [ Card.border ]
              [ Button.render Mdl [1,0] mdl
                  [ Button.ripple, Button.accent ]
                  [ text "<" ]
              , Button.render Mdl [1,1] mdl
                  [ Button.ripple, Button.accent ]
                  [ text ">" ]
              , Options.styled span
                  [ Typo.body1, white, cs "screen-desc" ]
                  [ text screen.description ]
              ]
          ]
      Nothing -> div [ ] [ ]
  else
    div [ ] [ ]


chip : String -> Html Msg
chip str =
  Chip.span [ cs "noselect" ] [ Chip.content [] [ text str ] ]


licenseLink : String -> String -> Html Msg
licenseLink url name =
  a [ class "align-top", href url ] [ text name ]

license : String -> Html Msg
license name =
  case name of
    "MIT" ->
      licenseLink "http://choosealicense.com/licenses/mit/" name
    "Apache 2.0" ->
      licenseLink "http://choosealicense.com/licenses/apache-2.0/" name
    "BSD" ->
      licenseLink "http://choosealicense.com/licenses/bsd-2-clause/" name
    "GPL v3" ->
      licenseLink "http://choosealicense.com/licenses/gpl-3.0/" name
    "AGPL v3" ->
      licenseLink "http://choosealicense.com/licenses/agpl-3.0/" name
    "LGPL v3" ->
      licenseLink "http://choosealicense.com/licenses/lgpl-3.0/" name
    "WTFPL" ->
      licenseLink "http://choosealicense.com/licenses/wtfpl/" name
    "GPL v2" ->
      licenseLink "http://choosealicense.com/licenses/gpl-2.0/" name
    "CC0" ->
      licenseLink "http://choosealicense.com/licenses/cc0-1.0/" name
    "zlib" ->
      licenseLink "http://choosealicense.com/licenses/zlib/" name
    "EPL" ->
      licenseLink "http://choosealicense.com/licenses/epl-1.0/" name
    name ->
      text name


versionLabel : Version -> Tabs.Label a
versionLabel version =
  Tabs.label [] [ text version.version ]

subtitle : String -> Html Msg
subtitle str =
  Options.styled p [ Typo.button, cs "subtitle" ] [ text str ]

versionDesc : String -> Version -> Html Msg
versionDesc name version =
  div [ ]
    [ subtitle "Installation"
    , div [ class "padding-bottom" ] [ div [ class "code" ] [ text <| "hpm install " ++ name ++ "@" ++ version.version ] ]
    , subtitle "Changelog"
    , Markdown.toHtml [ class "padding-bottom" ] version.changes
    ]


file : PkgVersionFile -> Html Msg
file file =
  Lists.li []
    [ Lists.content []
      [ span [ class "list-icon" ] [ Lists.icon "insert_drive_file" [ Icon.size18, cs "noselect" ] ]
      , span [ class "cell align-top list-white" ] [ text (file.dir ++ "/") ]
      , a [ class "cell align-top", href file.url ] [ text file.name ]
      ]
    ]

files : Version -> Html Msg
files version =
  div
    [ class "files" ]
    ( case version.files of
        x::_ ->
          [ subtitle "Files"
          , div [ class "list-of-cards" ]
              [ Lists.ul [ ] (map file version.files) ]
          ]
        [ ] ->
          [ subtitle "No files" ]
    )


dependencies : Version -> Html Msg
dependencies version =
  case version.depends of
    x::_ ->
      div [ class "dep-block list-of-cards" ]
        [ subtitle "Depends on"
        , Lists.ul [ ]
            ( map
                ( \d ->
                  ( Lists.li
                      [ Lists.withSubtitle ]
                      [ Lists.content [ ]
                          [ span [ class "list-icon" ] [ Lists.icon "folder" [ Icon.size18, cs "noselect" ] ]
                          , a [ href ("#packages/" ++ d.name) ] [ text d.name ]
                          , Lists.subtitle [ ]
                              [ span [ class "list-cell" ] [ text d.version ] ]
                          ]
                      ]
                  )
                )
                version.depends
            )
        ]
    [ ] ->
      div [ class "dep-block" ] [ subtitle "No dependencies" ]


detailsCard : PackageData -> Package -> Html Msg
detailsCard data package =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ]
        [ Card.head [ white ] [ text package.name ]
        , Card.subhead [ ]
            [ span [ class "card-subtitle-icon noselect" ] [ Icon.view "person" [ Icon.size18 ] ]
            , span [ class "align-top" ] [ text ( join ", " package.authors ) ]
            , span [ class "card-subtitle-icon card-license noselect" ] [ Icon.view "copyright" [ Icon.size18 ] ]
            , span [ class "align-top" ] [ license package.license ]
            ]
        ]
    , Card.menu [ white ]
        [ Menu.render Mdl [20] data.mdl
            [ Menu.ripple, Menu.bottomRight ]
            [ Menu.item
                [ Menu.disabled ]
                [ text "Edit" ]
            , Menu.item
                [ Menu.disabled
                , Menu.divider
                ]
                [ text "Delete" ]
            , Menu.item
                [ ]
                [ text "Share" ]
            ]
        ]
    , Card.text [ white ] [ Markdown.toHtml [] package.description ]
    , Card.actions [ ] ( map chip package.tags )
    , Card.actions [ white, cs "version-tabs" ]
        [ let versions = reverse <| sortBy .version package.versions
          in
            Tabs.render Mdl [0] data.mdl
              [ Tabs.ripple
              , Tabs.onSelectTab (\num -> PackageMsg (PMsg.GoToVersion num))
              , Tabs.activeTab data.version
              ]
              ( map versionLabel versions )
              [ case versions !! data.version of
                  Just version ->
                    div
                      [ class "page" ]
                      [ versionDesc package.name version
                      , Grid.grid [ cs "no-padding-grid" ]
                          [ Grid.cell
                              [ Grid.size Grid.Desktop 6
                              , Grid.size Grid.Tablet 8
                              , Grid.size Grid.Phone 4
                              ]
                              [ files version ]
                          , Grid.cell
                              [ Grid.size Grid.Desktop 6
                              , Grid.size Grid.Tablet 8
                              , Grid.size Grid.Phone 4
                              ]
                              [ dependencies version ]
                          ]
                      ]
                  Nothing ->
                    div [ class "error" ] [ text "Wrong version code!" ]
              ]
        ]
    ]


notFoundCard : Html Msg
notFoundCard =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ ] [ Card.head [ white ] [ text "Nothing found!" ] ]
    , Card.text [ white ]
        [ div [ ] [ text "No packages with this name was found in repository." ]
        , div [ ] [ text "Check the spelling, or try different name, please." ]
        ]
    ]


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
      ( case head data.packages of
          Just package ->
            [ screensCard data.mdl package
            , detailsCard data package
            ]
          Nothing ->
            [ notFoundCard ]
      )
