module User.Messages exposing (..)

import Package.Models exposing (Package)
import User.Models exposing (User, Profile)

type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | LogIn String String
  | LoggedIn
  | LogOut
  | LoggedOut
  | FetchUser String
  | UserFetched User
  | CheckSession
  | SessionChecked Profile
  | Register User
  | Registered
  | PackagesFetched (List Package)
  -- Navigation
  | GoToAuth
  | GoToRegister
  | GoToProfile
  -- Other
  | InputNickname String
  | InputPassword String
  | InputRetryPassword String
  | InputEmail String
  | InputKey Int