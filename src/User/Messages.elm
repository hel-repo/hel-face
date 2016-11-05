module User.Messages exposing (..)

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
  -- Navigation
  | GoToAuth
  | GoToRegister
  -- Other
  | InputNickname String
  | InputPassword String
  | InputRetryPassword String
  | InputEmail String
  | InputKey Int