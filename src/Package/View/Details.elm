module Package.View.Details exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, target)
import Html.Events exposing (on)
import Json.Decode as Json
import List
import String exposing (join)

import Markdown exposing (defaultOptions)

import Material.Button as Button
import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Grid as Grid
import Material.Icon as Icon
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (cs, attribute)
import Material.Progress as Progress
import Material.Spinner as Loading
import Material.Tabs as Tabs
import Material.Typography as Typo

import Base.Messages exposing (Msg(..))
import Base.Helpers.Search exposing (queryPkgAll, queryPkgByTag)
import Base.Models.Network exposing (firstPage)
import Base.Models.Package exposing (Package, Version, VersionDependency, VersionFile)
import Base.Helpers.Tools exposing ((!!))
import Base.Network.Url as Url
import Package.Messages as PMsg
import Package.Models exposing (PackageData)


onLoad : msg -> Attribute msg
onLoad message =
  on "load" (Json.succeed message)

screensCard : PackageData -> Package -> Html Msg
screensCard data package =
  if not (List.isEmpty package.screenshots) then
    case package.screenshots !! data.screenshot of
      Just screen ->
        Card.view
          [ Elevation.e2, cs "screen-card" ]
          [ Card.actions
              [ cs "screen-img" ]
              [ img
                  [ src screen.url
                  , onLoad <| PackageMsg PMsg.ScreenshotLoaded
                  ] []
              ]
          , ( if data.screenshotLoading then
                Card.actions [ cs "progress" ] [ div [] [ Progress.indeterminate ] ]
              else
                Card.actions [ cs "no-progress" ] []
            )
          , Card.actions
              [ Card.border ]
              [ Button.render Mdl [1,0] data.mdl
                  [ Button.ripple
                  , Button.accent
                  , if data.screenshot > 0 then
                      Options.nop
                    else
                      Button.disabled
                  , Options.onClick <| PackageMsg PMsg.PreviousScreenshot
                  ]
                  [ text "<" ]
              , Button.render Mdl [1,1] data.mdl
                  [ Button.ripple
                  , Button.accent
                  , if data.screenshot < (List.length package.screenshots - 1) then
                      Options.nop
                    else
                      Button.disabled
                  , Options.onClick <| PackageMsg PMsg.NextScreenshot
                  ]
                  [ text ">" ]
              , Options.styled span
                  [ Typo.body1, cs "screen-desc" ]
                  [ text screen.description ]
              ]
          ]
      Nothing -> div [ ] [ ]
  else
    div [ ] [ ]


chip : String -> Html Msg
chip str =
  Chip.span
    [ Options.onClick <| RoutePackageList <| firstPage <| queryPkgByTag queryPkgAll str
    , cs "noselect"
    ]
    [ Chip.content [] [ text str ] ]


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
    "Apache-2.0" ->
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
    , div [ class "padding-bottom" ] [ div [ class "code install-code" ] [ text <| "hpm install " ++ name ++ "@" ++ version.version ] ]
    , subtitle "Changelog"
    , Markdown.toHtmlWith { defaultOptions | sanitize = True } [ class "padding-bottom" ] version.changes
    ]


file : VersionFile -> Html Msg
file file =
  Lists.li [ cs "mdl-shadow--2dp" ]
    [ Lists.content []
      [ span [ class "list-icon" ] [ Lists.icon "insert_drive_file" [ Icon.size18 ] ]
      , span [ class "cell align-top list-white" ] [ text (file.dir ++ "/") ]
      , a [ class "cell align-top", href file.url, target "_blank" ] [ text file.name ]
      ]
    ]

files : Version -> Html Msg
files version =
  case version.files of
    x::_ ->
      div
        [ class "files list-of-cards" ]
        [ subtitle "Files"
        , Lists.ul [] ( List.map file version.files )
        ]
    [ ] ->
      div [ class "files" ] [ subtitle "No files" ]


dependency : VersionDependency -> Html Msg
dependency d =
  Lists.li
    [ Lists.withSubtitle, cs "mdl-shadow--2dp" ]
    [ Lists.content [ ]
        [ span [ class "list-icon" ] [ Lists.icon "folder" [ Icon.size18 ] ]
        , a [ href <| Url.package d.name, target "_blank" ] [ text d.name ]
        , Lists.subtitle [ ]
            [ span [ class "list-cell" ] [ text d.version ] ]
        ]
    ]

dependencies : Version -> Html Msg
dependencies version =
  case version.depends of
    x::_ ->
      div
        [ class "dep-block list-of-cards" ]
        [ subtitle "Depends on"
        , Lists.ul [ ] ( List.map dependency version.depends )
        ]
    [ ] ->
      div [ class "dep-block" ] [ subtitle "No dependencies" ]


detailsCard : PackageData -> Package -> Html Msg
detailsCard data package =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ]
        [ Card.head [] [ text package.name ]
        , Card.subhead [ ]
            [ span [ class "card-subtitle-icon noselect" ]
                [ Icon.view "person" [ Icon.size18, Options.attribute <| Html.Attributes.title "Authors of package" ] ]
            , span [ class "align-top" ] [ text ( join ", " package.authors ) ]
            , span [ class "card-subtitle-icon card-license noselect" ]
                [ Icon.view "copyright" [ Icon.size18, Options.attribute <| Html.Attributes.title "Source code license" ] ]
            , span [ class "align-top" ] [ license package.license ]
            , span [ class "card-subtitle-icon card-license noselect" ]
                [ Icon.view "turned_in_not" [ Icon.size18, Options.attribute <| Html.Attributes.title "Package maintainers" ] ]
            , span [ class "align-top" ] [ text ( join ", " package.owners ) ]
            ]
        ]
    , Card.menu [ cs "noselect" ]
        ( if (List.member data.session.user.nickname package.owners)
          || (List.member "admins" data.session.user.groups) then
            [ Menu.render Mdl [20] data.mdl
                [ Menu.ripple, Menu.bottomRight ]
                [ Menu.item
                    [ Menu.onSelect <| SomethingOccurred "Thanks!"
                    , Menu.divider ]
                    [ Icon.view "favorite_border" [ cs "menu-icon" ], text "Like" ]
                , Menu.item
                    [ Menu.onSelect <| RoutePackageEdit package.name ]
                    [ Icon.view "mode_edit" [ cs "menu-icon" ], text "Edit" ]
                , Menu.item
                    [ Menu.onSelect <| PackageMsg (PMsg.RemovePackage package.name) ]
                    [ Icon.view "delete" [ cs "menu-icon danger" ], text "Delete" ]
                ]
            ]
          else
            [ Menu.render Mdl [20] data.mdl
                [ Menu.ripple, Menu.bottomRight ]
                [ Menu.item
                    [ Menu.onSelect <| SomethingOccurred "Thank you!" ]
                    [ Icon.view "favorite_border" [ cs "menu-icon" ], text "Like" ]
                ]
            ]
        )
    , Card.text [] [ Markdown.toHtmlWith { defaultOptions | sanitize = True } [] package.description ]
    , Card.actions [] ( List.map chip package.tags )
    , Card.actions [ cs "version-tabs" ]
        [ Tabs.render Mdl [0] data.mdl
            [ Tabs.ripple
            , Tabs.onSelectTab (\num -> PackageMsg (PMsg.GoToVersion num))
            , Tabs.activeTab data.version
            ]
            ( List.map versionLabel package.versions )
            [ case package.versions !! data.version of
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
                  div [ class "banner" ] [ text "This package does not have any versions. So, you can not download it." ]
            ]
        ]
    ]


notFoundCard : Html Msg
notFoundCard =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [] [ Card.head [] [ text "Nothing found!" ] ]
    , Card.text []
        [ div [] [ text "No packages with this name was found in repository." ]
        , div [] [ text "Check the spelling, or try different name, please." ]
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
      ( if String.isEmpty data.package.name then
          [ notFoundCard ]
        else
          [ screensCard data data.package
          , detailsCard data data.package
          ]
      )