module Base.Tools exposing (..)

import List exposing (map, head, drop)
import Task exposing (Task)

import Base.Messages exposing (Msg)


wrapMsg : Msg -> Cmd Msg
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())

batchMsg : List Msg -> Cmd Msg
batchMsg list =
  Cmd.batch ( map wrapMsg list )

infixl 9 !!
(!!) : List a -> Int -> Maybe a
(!!) xs n  = head (drop n xs)
