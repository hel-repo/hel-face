module User.Models exposing (..)

import Material

import Package.Models exposing (Package)


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
  , loading : Bool
  , packages : List Package
  }

emptyUserData : Material.Model -> UserData
emptyUserData materialModel =
  { mdl = materialModel
  , user = emptyUser
  , loggedin = False
  , loading = False
  , packages = []
  }