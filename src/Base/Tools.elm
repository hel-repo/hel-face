module Base.Tools exposing (..)

import List exposing (drop, head, map)
import Task exposing (Task)


zip : List a -> List b -> List (a, b)
zip = List.map2 (,)

wrapMsg : a -> Cmd a
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())

batchMsg : List a -> Cmd a
batchMsg list =
  Cmd.batch ( map wrapMsg list )

-- Get element by index
infixl 9 !!
(!!) : List a -> Int -> Maybe a
(!!) xs n  = head (drop n xs)

-- Batch inner messages
(~) : (model, Cmd msg) -> List outer -> (model, Cmd msg, List outer)
(~) (model, cmd) outerMessages =
  (model, cmd, outerMessages)
