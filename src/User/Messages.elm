module User.Messages exposing (..)

type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | LogIn String String
  | LoggedIn
  | LogOut
  | LoggedOut
  -- Navigation
  | GoToAuth
  | GoToRegister
  -- Other
  | InputNickname String
  | InputPassword String
  | InputKey Int