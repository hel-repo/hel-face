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
import Material.List as Lists
import Material.Options as Options exposing (cs)
import Material.Spinner as Loading
import Material.Tabs as Tabs
import Material.Icon as Icon

import Base.Messages exposing (Msg(..))
import Base.Models exposing (materialModel)
import Package.Messages as PMsg
import Package.Models exposing (PackageListData, Version, PkgVersionDependency)
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

depDesc : PkgVersionDependency -> Html Msg
depDesc dep =
  Lists.li [ Lists.withBody ]
    [ Lists.content []
      [ span [ class "dep-name" ] [ text dep.name ]
      , Lists.body []
        [ span [ class "dep-item dep-item-spec" ] [ text dep.version ]
        , span [ class "dep-item" ] [ text dep.deptype ]
        ]
      ]
    ]

versionLabel : Version -> Tabs.Label a
versionLabel version =
  Tabs.label [] [ text version.version ]

versionDesc : Version -> Html Msg
versionDesc version =
  div [ class "page" ]
    [ span [ class "ver-changes" ] [ text version.changes ]
    , div [ class "dependencies" ] [ Lists.ul [] ( map depDesc version.depends ) ]
    ]


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
                [ span [ ] [ Icon.view "person" [ Icon.size18 ] ]
                , span [ class "align-top" ] [ text ( join ", " package.authors ) ]
                , span [ class "card-license" ] [ Icon.view "copyright" [ Icon.size18 ] ]
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
                    Just version -> versionDesc version
                    Nothing -> div [ class "error" ] [ text "Wrong version code!" ]
                ]
              ]
            ]
          ]
      Nothing ->
        text "404: Package not found!"
