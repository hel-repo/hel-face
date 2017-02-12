module User.Messages exposing (..)

import Http exposing (Error)

import Base.Helpers.Search exposing (PackagePage)
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
  | FetchUsers String
  | UsersFetched (Result Error (List User))
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
  | GoToUserList String
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
