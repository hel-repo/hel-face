module Base.Models.User exposing (..)

type alias User =
  { nickname : String
  , password : String
  , retryPassword : String
  , email : String
  , groups : List String
  }

emptyUser : User
emptyUser = { nickname = "", password = "", retryPassword = "", email = "", groups = [] }

userByName : String -> User
userByName name = { emptyUser | nickname = name }


type alias Session =
  { user : User
  , loggedin : Bool
  , apiVersion : String
  }

emptySession : Session
emptySession =
  { user = emptyUser
  , loggedin = False
  , apiVersion = "0.0.0"
  }
