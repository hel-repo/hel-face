module User.Messages exposing (..)

import Http exposing (Error)

import Base.Http exposing (ApiResult)
import Package.Models exposing (Package)
import User.Models exposing (User, Session)


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
  | CheckSession
  | SessionChecked (Result Error Session)
  | Register User
  | Registered (Result Error ApiResult)
  | PackagesFetched (Result Error (List Package))
  -- Navigation
  | GoToAuth
  | GoToRegister
  | GoToProfile
  | GoToAbout
  -- Other
  | InputNickname String
  | InputPassword String
  | InputRetryPassword String
  | InputEmail String
  | InputKey Int