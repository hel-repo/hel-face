module Package.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import List exposing (head, map, reverse, sortBy)

import Material.Button as Button
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

import Base.Input exposing (keyDecoder)
import Base.Messages exposing (Msg(..))
import Base.Tools exposing ((!!))
import Package.Messages as PMsg
import Package.Models exposing (..)


chip : (String -> PMsg.Msg) -> String -> Html Msg
chip msg str =
  Chip.span
    [ Chip.deleteIcon "cancel"
    , Chip.deleteClick <| PackageMsg (msg str)
    , cs "noselect"
    ]
    [ Chip.content [] [ text str ] ]


versionLabel : Version -> Tabs.Label a
versionLabel version =
  Tabs.label [] [ text version.version ]

subtitle : String -> Html Msg
subtitle str =
  p [ class "subtitle" ] [ text str ]


file : PackageData -> PkgVersionFile -> Html Msg
file data file =
  div [ class "edit-card-item" ]
    [ Button.render Mdl [41] data.mdl
        [ Button.icon
        , Button.ripple
        , cs "edit-card-close noselect"
        ]
        [ Icon.i "close"]
    , div [ class "edit-card-desc-box" ]
        [ span [ class "list-icon" ] [ Lists.icon "folder" [ Icon.size18, cs "noselect" ] ]
        , Textfield.render Mdl [42] data.mdl
            [ Textfield.label "Path"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value file.dir
            ]
        ]
    , div [ class "edit-card-desc-box" ]
        [ span [ class "list-icon" ] [ Lists.icon "insert_drive_file" [ Icon.size18, cs "noselect" ] ]
        , Textfield.render Mdl [43] data.mdl
            [ Textfield.label "File name"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value file.name
            ]
        ]
    , div [ class "edit-card-desc-box" ]
        [ span [ class "list-icon" ] [ Lists.icon "link" [ Icon.size18, cs "noselect" ] ]
        , Textfield.render Mdl [44] data.mdl
            [ Textfield.label "URL"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value file.url
            ]
        ]
    ]

files : PackageData -> Version -> Html Msg
files data version =
  div
    [ class "files" ]
    [ subtitle "Files"
    , Button.render Mdl [40] data.mdl
        [ Button.raised
        , Button.ripple
        , cs "edit-card-add-button"
        ]
        [ text "New file" ]
    , div [] (map (file data) version.files)
    ]


dependency : PackageData -> PkgVersionDependency -> Html Msg
dependency data d =
  div [ class "edit-card-item" ]
    [ Button.render Mdl [51] data.mdl
        [ Button.icon
        , Button.ripple
        , cs "edit-card-close"
        ]
        [ Icon.i "close"]
    , div [ class "edit-card-desc-box" ]
        [ span [ class "list-icon" ] [ Lists.icon "extension" [ Icon.size18, cs "noselect" ] ]
        , Textfield.render Mdl [52] data.mdl
            [ Textfield.label "Package name"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value d.name
            ]
        ]
    , div [ class "edit-card-desc-box" ]
        [ span [ class "list-icon" ] [ Lists.icon "dns" [ Icon.size18, cs "noselect" ] ]
        , Textfield.render Mdl [53] data.mdl
            [ Textfield.label "Version"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value d.version
            ]
        ]
    ]

dependencies : PackageData -> Version -> Html Msg
dependencies data version =
  div
    [ class "dep-block" ]
    [ subtitle "Depends on"
    , Button.render Mdl [50] data.mdl
        [ Button.raised
        , Button.ripple
        , cs "edit-card-add-button"
        ]
        [ text "New dependency" ]
    , div [] ( map (dependency data) version.depends )
    ]


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
            , Textfield.onInput <| PMsg.InputName >> PackageMsg
            , cs "edit-card-title"
            ]
        , Textfield.render Mdl [12] data.mdl
            [ Textfield.label "License"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value package.license
            , Textfield.onInput <| PMsg.InputLicense >> PackageMsg
            ]
        ]
    , Card.text
        [ Card.border ]
        [ div [ ]
            [ subtitle "You can use Markdown markup language in description fields"
            , columns
                [ Textfield.render Mdl [14] data.mdl
                    [ Textfield.label "Full description"
                    , Textfield.floatingLabel
                    , Textfield.textarea
                    , Textfield.rows 6
                    , Textfield.value package.description
                    , Textfield.onInput <| PMsg.InputDescription >> PackageMsg
                    , cs "edit-card-desc-box"
                    ] ]
                [ Textfield.render Mdl [13] data.mdl
                    [ Textfield.label "Short description"
                    , Textfield.floatingLabel
                    , Textfield.textarea
                    , Textfield.rows 2
                    , Textfield.value package.shortDescription
                    , Textfield.onInput <| PMsg.InputShortDescription >> PackageMsg
                    , cs "edit-card-desc edit-card-desc-box"
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
            , Textfield.value data.tags.owner
            , Textfield.onInput <| PMsg.InputOwner >> PackageMsg
            , Textfield.on "keyup" <| keyDecoder (PMsg.InputKey >> PackageMsg)
            ]
        , div [] ( map (chip PMsg.RemoveOwner) package.owners )
        , Textfield.render Mdl [16] data.mdl
            [ Textfield.label "Author of program"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value data.tags.author
            , Textfield.onInput <| PMsg.InputAuthor >> PackageMsg
            , Textfield.on "keyup" <| keyDecoder (PMsg.InputKey >> PackageMsg)
            ]
        , div [] ( map (chip PMsg.RemoveAuthor) package.authors )
        , Textfield.render Mdl [17] data.mdl
            [ Textfield.label "Content tag"
            , Textfield.floatingLabel
            , Textfield.text'
            , Textfield.value data.tags.content
            , Textfield.onInput <| PMsg.InputContent >> PackageMsg
            , Textfield.on "keyup" <| keyDecoder (PMsg.InputKey >> PackageMsg)
            ]
        , div [] ( map (chip PMsg.RemoveContent) package.tags )
        ]
    , Card.text [ cs "version-tabs" ]
        [ subtitle "Add package versions and fill in version data"
        , Button.render Mdl [20] data.mdl
            [ Button.raised
            , Button.ripple
            , Button.onClick <| PackageMsg PMsg.AddVersion
            , cs "edit-card-add-button"
            ]
            [ Icon.i "add", text "Add version" ]
        , Button.render Mdl [21] data.mdl
            [ Button.raised
            , Button.ripple
            , Button.onClick <| PackageMsg PMsg.RemoveVersion
            , cs "edit-card-remove-button"
            ]
            [ Icon.i "delete", text "Remove version" ]
        , Tabs.render Mdl [25] data.mdl
            [ Tabs.ripple
            , Tabs.onSelectTab (\num -> PackageMsg (PMsg.GoToVersion num))
            , Tabs.activeTab data.version
            ]
            ( map versionLabel package.versions )
            [ case package.versions !! data.version of
                Just version ->
                  div
                    [ class "page" ]
                    [ columns
                        [ Textfield.render Mdl [30] data.mdl
                            [ Textfield.label "Version number"
                            , Textfield.floatingLabel
                            , Textfield.value version.version
                            ] ]
                        [ Textfield.render Mdl [31] data.mdl
                            [ Textfield.label "Version changes"
                            , Textfield.floatingLabel
                            , Textfield.textarea
                            , Textfield.rows 5
                            , Textfield.value version.changes
                            , cs "edit-card-desc-box"
                            ] ]
                    , columns [ files data version ] [ dependencies data version ]
                    ]
                Nothing ->
                  p [] [ text "No versions added..." ]
            ]
        ]
    , Card.text
        []
        [ Button.render Mdl [60] data.mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Button.onClick <| PackageMsg ( PMsg.SavePackage package )
            , cs "save-button"
            ]
            [ text "Save" ]
        , Button.render Mdl [61] data.mdl
            [ Button.raised
            , Button.ripple
            , Button.onClick <| RoutePackageDetails package.oldName
            ]
            [ text "Cancel" ]
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
      [ packageCard data data.package ]
