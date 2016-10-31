module User.Models exposing (..)

import Material


type alias UserData =
  { mdl : Material.Model
  , login : String
  , password : String
  , error : String
  , loading : Bool
  }