module Package.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import List exposing (head, map, reverse, sortBy)

import Material.Card as Card
import Material.Chip as Chip
import Material.Elevation as Elevation
import Material.Grid as Grid
import Material.Icon as Icon
import Material.List as Lists
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading
import Material.Tabs as Tabs
import Material.Textfield as Textfield

import Base.Messages exposing (Msg(..))
import Base.Tools exposing ((!!))
import Package.Messages as PMsg
import Package.Models exposing (..)


chip : String -> Html Msg
chip str =
  Chip.span
    [ Chip.deleteIcon "cancel",
      cs "noselect"
    ]
    [ Chip.content [] [ text str ] ]


versionLabel : Version -> Tabs.Label a
versionLabel version =
  Tabs.label [] [ text version.version ]

subtitle : String -> Html Msg
subtitle str =
  p [ class "subtitle" ] [ text str ]


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


columns : List (Html a) -> List (Html a) -> Html a
columns left right =
  Grid.grid [ cs "no-padding-grid" ]
    [ Grid.cell
        [ Grid.size Grid.Desktop 6
        , Grid.size Grid.Tablet 8
        , Grid.size Grid.Phone 4
        ]
        left
    , Grid.cell
        [ Grid.size Grid.Desktop 6
        , Grid.size Grid.Tablet 8
        , Grid.size Grid.Phone 4
        ]
        right
    ]


packageCard : PackageData -> Package -> Html Msg
packageCard data package =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [ Card.border ]
        [ Textfield.render Mdl [11] data.mdl
            [ Textfield.label "Package name"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value package.name
            , cs "edit-card-title"
            ]
        , Textfield.render Mdl [12] data.mdl
            [ Textfield.label "License"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value package.license
            ]
        ]
    , Card.text
        [ Card.border ]
        [ div [ ]
            [ subtitle "You can use Markdown markup language in description fields"
            , columns
                [ Textfield.render Mdl [13] data.mdl
                    [ Textfield.label "Short description"
                    , Textfield.floatingLabel
                    , Textfield.textarea
                    , Textfield.rows 2
                    , Textfield.value package.short_description
                    , cs "edit-card-desc edit-card-desc-box"
                    ] ]
                [ Textfield.render Mdl [14] data.mdl
                  [ Textfield.label "Full description"
                  , Textfield.floatingLabel
                  , Textfield.textarea
                  , Textfield.rows 6
                  , Textfield.value package.description
                  , cs "edit-card-desc-box"
                  ] ]
            ]
        ]
    , Card.text
        [ Card.border ]
        [ subtitle "Enter a value, and then press Enter"
        , Textfield.render Mdl [15] data.mdl
            [ Textfield.label "Package owner"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value ""  -- clear this field after input
            ]
        , div [] ( map chip package.owners )
        , Textfield.render Mdl [16] data.mdl
            [ Textfield.label "Author of program"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value ""
            ]
        , div [] ( map chip package.authors )
        , Textfield.render Mdl [17] data.mdl
            [ Textfield.label "Content tag"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value ""
            ]
        , div [] ( map chip package.tags )
        ]
    , Card.text [ cs "version-tabs" ]
        [ subtitle "Add package versions and fill in version data"
        , let versions = reverse <| sortBy .version package.versions
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
                      [ columns
                          [ Textfield.render Mdl [20] data.mdl
                              [ Textfield.label "Version number"
                              , Textfield.floatingLabel
                              , Textfield.value version.version
                              ] ]
                          [ Textfield.render Mdl [21] data.mdl
                              [ Textfield.label "Version changes"
                              , Textfield.floatingLabel
                              , Textfield.textarea
                              , Textfield.rows 5
                              , Textfield.value version.changes
                              , cs "edit-card-desc-box"
                              ] ]
                      , columns [ files version ] [ dependencies version ]
                      ]
                  Nothing ->
                    div [ class "error" ] [ text "Wrong version code!" ]
              ]
        ]
    ]


noPackageCard : Html Msg
noPackageCard =
  Card.view
    [ Elevation.e2 ]
    [ Card.title [] [ Card.head [] [ text "Something went wrong..." ] ]
    , Card.text [] [ div [] [ text "No package data was given, so there is nothing to edit. ;)" ] ]
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
            [ packageCard data package ]
          Nothing ->
            [ noPackageCard ]
      )