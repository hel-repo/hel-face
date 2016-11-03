module User.Models exposing (..)

import Material


-- Auxiliary model, used for checking a session
type alias Profile =
  { success : Bool
  , nickname : String
  , loggedin : Bool
  }

-- Actual User model
type alias User =
  { nickname : String
  , password : String
  , retryPassword : String
  , email : String
  , groups : List String
  }

emptyUser : User
emptyUser = { nickname = "", password = "", retryPassword = "", email = "", groups = [] }

-- User interface state
type alias UserData =
  { mdl : Material.Model
  , user : User
  , loggedin : Bool
  , error : String
  , loading : Bool
  }