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
  | Register User
  | Registered (Result Error ApiResult)
  | PackagesFetched (Result Error (List Package))
  -- Navigation
  | GoToAuth
  | GoToRegister
  | GoToProfile String
  | GoToAbout
  -- Other
  | InputNickname String
  | InputPassword String
  | InputRetryPassword String
  | InputEmail String
  | InputKey Int