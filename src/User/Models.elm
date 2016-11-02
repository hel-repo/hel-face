module User.Models exposing (..)

import Material


type alias User =
  { nickname : String
  , password : String
  , groups : List String
  }

type alias UserData =
  { mdl : Material.Model
  , user : User
  , loggedin : Bool
  , error : String
  , loading : Bool
  }