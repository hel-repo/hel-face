module User.Messages exposing (..)

import Http exposing (Error)

import Base.Helpers.Search exposing (PackagePage, UserPage)
import Base.Models.Network exposing (ApiResult)
import Base.Models.User exposing (User)


type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | LogIn String String
  | LoggedIn (Result Error ApiResult)
  | LogOut
  | LoggedOut (Result Error ApiResult)
  | FetchUser Bool String
  | UserFetched Bool (Result Error User)
  | FetchUsers UserPage
  | UsersFetched (Result Error UserPage)
  | NextPage
  | PreviousPage
  | Register User
  | Registered (Result Error ApiResult)
  | SaveUser User
  | UserSaved (Result Error ApiResult)
  | RemoveUser String
  | UserRemoved (Result Error ApiResult)
  | PackagesFetched (Result Error (PackagePage))
  -- Navigation
  | GoToAuth
  | GoToRegister
  | GoToProfile String
  | GoToUserList UserPage
  | GoToUserEdit String
  | GoToAbout
  -- Other
  | InputNickname String
  | InputPassword String
  | InputRetryPassword String
  | InputEmail String
  | InputGroup String
  | RemoveGroup String
  | InputKey Int
  | ChangeLanguage String
