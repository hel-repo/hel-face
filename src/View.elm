module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, href, src)
import Json.Decode as Decode

import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs)
import Material.Snackbar as Snackbar
import Material.Textfield as Textfield

import About
import Localization as L
import Models exposing (..)
import Base.Config as Config
import Base.Messages exposing (Msg(..))
import Base.Models.Generic exposing (SnackbarType(..))
import Base.Network.Url as Url
import Package.View.List
import Package.View.Details
import Package.View.Edit
import Routing exposing (Route(..))
import User.Messages as UMsg
import User.View.Auth
import User.View.Profile
import User.View.Register
import User.View.List
import User.View.Edit


keyDecoder : Decode.Decoder Msg
keyDecoder =
  Decode.map InputKey
    <| Decode.map identity
        (Decode.at ["keyCode"] Decode.int)


view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl
    [ Layout.fixedHeader ]
    { header =
      [ div
          [ class "header" ]
          [ a
              [ class "header-title noselect", href Url.home ]
              [ img [ src model.logo, class "header-image" ] [] ]
          , div [ class "search" ]
              [ Textfield.render Mdl [0] model.mdl
                  [ Options.input
                      [ Options.attribute <| attribute "spellcheck" "false"
                      , Options.attribute <| attribute "autocomplete" "off"
                      , Options.attribute <| attribute "autocorrect" "off"
                      , Options.attribute <| attribute "autocapitalize" "off"
                      ]
                  , Textfield.value model.search
                  , Options.onInput InputSearch
                  , Options.on "keyup" keyDecoder
                  ] []
              , Button.render Mdl [1] model.mdl
                  [ Button.icon
                  , Button.ripple
                  , cs "search-icon noselect"
                  , Options.onClick <| InputKey Config.enterKey
                  ]
                  [ Icon.i "search"]
              ]
          , if model.session.loggedin then
              div [ class "buttons noselect" ]
                  [ Button.render Mdl [5] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Options.onClick <| RoutePackageEdit ""
                      ]
                      [ Icon.view "add_circle_outline" [ Icon.size36 ] ]
                  , Button.render Mdl [4] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Options.onClick RouteProfile
                      ]
                      [ Icon.view "account_circle" [ Icon.size36 ] ]
                  , Button.render Mdl [3] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Options.onClick RouteAbout
                      ]
                      [ Icon.view "help_outline" [ Icon.size36 ] ]
                  , Button.render Mdl [2] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Options.onClick <| UserMsg UMsg.LogOut
                      ]
                      [ Icon.view "exit_to_app" [ Icon.size36 ] ]
                  ]
            else
              div [ class "buttons noselect" ]
                  [ Button.render Mdl [3] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Options.onClick RouteAuth
                      ]
                      [ Icon.view "fingerprint" [ Icon.size36 ] ]
                  , Button.render Mdl [2] model.mdl
                      [ Button.minifab
                      , Button.ripple
                      , Options.onClick RouteAbout
                      ]
                      [ Icon.view "help_outline" [ Icon.size36 ] ]
                  ]
          ]
      , div [ let c = case model.snackbarType of
                        Error -> "snackbar-error"
                        Info -> "snackbar-info"
              in class c ]
            [ Snackbar.view model.snackbar |> Html.map Snackbar ]
      ]
    , drawer = []
    , tabs = ( [], [] )
    , main = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
  case model.route of
    PackageListRoute searchData ->
      Package.View.List.view model.packageData

    PackageRoute name ->
      Package.View.Details.view model.packageData

    PackageEditRoute name ->
      Package.View.Edit.view model.packageData

    AuthRoute ->
      User.View.Auth.view model.userData

    RegisterRoute ->
      User.View.Register.view model.userData

    ProfileRoute nickname ->
      User.View.Profile.view model.userData

    UserListRoute group ->
      User.View.List.view model.userData

    UserEditRoute nickname ->
      User.View.Edit.view model.userData

    AboutRoute ->
      About.view model.session

    NotFoundRoute ->
      div
        [ class "page" ]
        [ Card.view
          [ Elevation.e2 ]
          [ Card.title [] [ Card.head [] [ text (L.get model.session.lang L.error404) ] ]
          , Card.text [] [ text (L.get model.session.lang L.checkSpelling) ]
          ]
        ]
