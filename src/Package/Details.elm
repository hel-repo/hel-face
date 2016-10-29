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
import Material.Icon as Icon
import Material.List as Lists
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading
import Material.Tabs as Tabs

import Base.Messages exposing (Msg(..))
import Base.Models exposing (materialModel)
import Package.Messages as PMsg
import Package.Models exposing (PackageListData, Version, PkgVersionFile, PkgVersionDependency)
import Base.Tools exposing ((!!))


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


versionLabel : Version -> Tabs.Label a
versionLabel version =
  Tabs.label [] [ text version.version ]

versionDesc : Version -> Html Msg
versionDesc version =
  p [ class "ver-changes" ] [ text version.changes ]


row : PkgVersionFile -> Html Msg
row file =
  div [ class "file" ]
    [ Icon.view "code" [Icon.size18]
    , span [ class "cell align-top" ] [ text (file.dir ++ "/") ]
    , a [ class "cell align-top", href file.url ] [ text file.name ]
    ]


dependencies : Version -> Html Msg
dependencies version =
  p [ class "dependencies" ]
    ( case version.depends of
        x::_ ->
          [ text "Depends on: "
          , div [ ]
              ( map
                  (\d -> (a [ class "dependency", href ("#packages/" ++ d.name) ] [ text (d.name ++ " : " ++ d.version) ]))
                  version.depends
              )
          ]
        [ ] ->
          [ text "No dependencies." ] )


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
                [ span [ class "card-subtitle-icon" ] [ Icon.view "person" [ Icon.size18 ] ]
                , span [ class "align-top" ] [ text ( join ", " package.authors ) ]
                , span [ class "card-subtitle-icon card-license" ] [ Icon.view "copyright" [ Icon.size18 ] ]
                , span [ class "align-top" ] [ license package.license ]
                ]
              ]
            , Card.text [ white ] [ Markdown.toHtml [] package.description ]
            , Card.menu [ ] ( map chip package.tags )
            , Card.actions [ white, cs "version-tabs" ]
              [ Tabs.render Mdl [0] materialModel
                [ Tabs.ripple
                , Tabs.onSelectTab (\num -> PackageMsg (PMsg.GoToVersion num))
                , Tabs.activeTab data.version
                ]
                ( map versionLabel package.versions )
                [ case package.versions !! data.version of
                    Just version ->
                      div [ class "page" ]
                        [ versionDesc version
                        , div [ class "files" ] (map row version.files)
                        , dependencies version
                        ]
                    Nothing -> div [ class "error" ] [ text "Wrong version code!" ]
                ]
              ]
            ]
          ]
      Nothing ->
        div
          [ class "page" ]
          [ Card.view
            [ Elevation.e2 ]
            [ Card.title [ ] [ Card.head [ white ] [ text "Nothing found!" ] ]
            , Card.text [ white ]
              [ div [ ] [ text "No packages with this name was found in repository." ]
              , div [ ] [ text "Check the spelling, or try different name, please." ]
              ]
            ]
          ]
