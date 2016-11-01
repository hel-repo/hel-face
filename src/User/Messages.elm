module User.Messages exposing (..)

type Msg
  = NoOp
  | ErrorOccurred String
  -- Network
  | LogIn String String
  | LoggedIn
  -- Navigation
  | GoToAuth
  | GoToRegister