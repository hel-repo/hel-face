module Base.Tools exposing (..)

import Task exposing (Task)


-- Wrap Messages to Commands
wrapMsg : a -> Cmd a
wrapMsg msg =
  Task.perform (always msg) (Task.succeed ())

batchMsg : List a -> Cmd a
batchMsg list =
  Cmd.batch ( List.map wrapMsg list )


-- Batch inner messages
(~) : (model, Cmd msg) -> List outer -> (model, Cmd msg, List outer)
(~) (model, cmd) outerMessages =
  (model, cmd, outerMessages)


-- Standart zip operator (that standart library lacks of)
zip : List a -> List b -> List (a, b)
zip = List.map2 (,)

-- Get element of a list by index
infixl 9 !!
(!!) : List a -> Int -> Maybe a
(!!) xs n  = List.head (List.drop n xs)

-- Manage unique list items
add : List a -> a -> List a
add list item =
  if List.member item list then
    list
  else
    item :: list

remove : List a -> a -> List a
remove list item =
  List.filter (\a -> a /= item) list

removeByIndex : Int -> List a -> List a
removeByIndex i xs =
  (List.take i xs) ++ (List.drop (i+1) xs)