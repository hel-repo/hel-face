module User.Messages exposing (..)

import Http exposing (Error)

import Base.Models exposing (ApiResult, Package, User)


type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | LogIn String String
  | LoggedIn (Result Error ApiResult)
  | LogOut
  | LoggedOut (Result Error ApiResult)
  | FetchUser String
  | UserFetched (Result Error User)
  | FetchUsers
  | UsersFetched (Result Error (List User))
  | Register User
  | Registered (Result Error ApiResult)
  | SaveUser User
  | UserSaved (Result Error ApiResult)
  | PackagesFetched (Result Error (List Package))
  -- Navigation
  | GoToAuth
  | GoToRegister
  | GoToProfile String
  | GoToUserList
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
