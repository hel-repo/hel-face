module User.Models exposing (..)

import Material

import Base.Models exposing (Package, Session, emptySession, User, emptyUser)


type alias UserData =
  { mdl : Material.Model
  , session : Session
  , user : User                 -- auxiliary user model, used by interfaces
  , packages : List Package     -- list of user packages (for profile page)
  , loading : Bool
  , validate : Bool             -- show validation messages below textboxes
  }                             -- (usually after "Send" or "Ok" button was pressed)

emptyUserData : Material.Model -> UserData
emptyUserData materialModel =
  { mdl = materialModel
  , session = emptySession
  , user = emptyUser
  , packages = []
  , loading = False
  , validate = False
  }