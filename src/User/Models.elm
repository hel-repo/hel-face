module User.Models exposing (..)

import Material


type alias UserData =
  { mdl : Material.Model
  , nickname : String
  , password : String
  , loggedin : Bool
  , error : String
  , loading : Bool
  }