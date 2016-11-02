module User.Messages exposing (..)

import User.Models exposing (User)

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
  -- Navigation
  | GoToAuth
  | GoToRegister
  -- Other
  | InputNickname String
  | InputPassword String
  | InputKey Int