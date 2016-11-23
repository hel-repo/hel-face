module User.Models exposing (..)

import Material

import Base.Models exposing (Package, Session, emptySession, User, emptyUser)


type Page = Auth | Edit | Other

type alias UserData =
  { mdl : Material.Model
  , session : Session
  , page : Page                 -- input selector
  , user : User                 -- auxiliary user model, used by profile / auth interfaces
  , users : List User           -- auxiliary model for user list interface
  , groupTag : String           -- for user edit dialog
  , packages : List Package     -- list of user packages (for profile page)
  , loading : Bool
  , validate : Bool             -- show validation messages below textboxes
  }                             -- (usually after "Send" or "Ok" button was pressed)

emptyUserData : Material.Model -> UserData
emptyUserData materialModel =
  { mdl = materialModel
  , session = emptySession
  , page = Other
  , user = emptyUser
  , users = []
  , groupTag = ""
  , packages = []
  , loading = False
  , validate = False
  }