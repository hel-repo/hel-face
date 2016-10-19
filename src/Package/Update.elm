module Package.Update exposing (..)

import Package.Messages exposing (Msg(..))
import Package.Models exposing (..)

update : Msg -> List Package -> ( List Package, Cmd Msg )
update message packages =
  case message of
    NoOp ->
      ( packages, Cmd.none )