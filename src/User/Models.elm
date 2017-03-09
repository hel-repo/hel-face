module User.Models exposing (..)

import Material

import Base.Helpers.Search exposing (PackagePage, queryPkgAll, UserPage, queryUsrAll)
import Base.Models.Network exposing (firstPage)
import Base.Models.User exposing (Session, emptySession, User, emptyUser)


type UIPage = Auth | Edit | Other

type alias UserData =
  { mdl : Material.Model
  , session : Session
  , uipage : UIPage             -- input selector
  , user : User                 -- auxiliary user model, used by profile / auth interfaces
  , page : UserPage             -- auxiliary model for user list interface
  , groupTag : String           -- for user edit dialog
  , oldNickname : String        -- for user edit dialog
  , packages : PackagePage      -- list of user packages (for profile page)
  , loading : Bool
  , validate : Bool             -- show validation messages below textboxes
  }                             -- (usually after "Send" or "Ok" button was pressed)

emptyUserData : Material.Model -> UserData
emptyUserData materialModel =
  { mdl = materialModel
  , session = emptySession
  , uipage = Other
  , user = emptyUser
  , page = firstPage queryUsrAll
  , groupTag = ""
  , oldNickname = ""
  , packages = firstPage queryPkgAll
  , loading = False
  , validate = False
  }
