module Update exposing (..)

import Material

import Messages exposing (Msg(..))
import Models exposing (..)
import Package.Messages as PMsg
import Package.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Mdl msg' ->
      Material.update msg' model

    -- Hook package messages up
    PackageMsg subMsg ->
      let
        ( updatedList, cmd ) =
          Package.Update.update subMsg model.list
      in
        ( { model | list = updatedList }, Cmd.map PackageMsg cmd )

    SelectTab num ->
      let
        newModel = { model | selectedTab = num }
      in
        if num == 0 then
          update ( PackageMsg PMsg.FetchPackages ) newModel
        else
          newModel ! []