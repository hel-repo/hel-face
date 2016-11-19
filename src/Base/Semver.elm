module Base.Semver exposing (sort)

import List exposing (append, foldl, length, repeat, reverse, sortWith)
import Regex exposing (HowMany(..), split, regex)
import String exposing (toInt)

import Base.Tools exposing (zip)
import Package.Models exposing (Version)


splitToParts : Version -> List String
splitToParts version =
  split All (regex "[.\\-+]") version.version


zipParts : List String -> List String -> List (String, String)
zipParts a b =
  let
    aa = if length a < length b then append a (repeat (length b - length a) "") else a
    ab = if length b < length a then append b (repeat (length a - length b) "") else b
  in zip aa ab

negative : Order -> Order
negative order =
  case order of
    GT -> LT
    EQ -> EQ
    LT -> GT

process : (String, String) -> Order -> Order
process (a, b) acc =
  if acc == EQ then
    let
      (ia, ib) = (Result.withDefault -1 (toInt a), Result.withDefault -1 (toInt b))
    in
      if ia /= -1 && ib /= -1 then
        compare ia ib
      else
        if a == "" || b == "" then
          negative <| compare a b
        else
          compare a b
  else
    acc


comparator : Version -> Version -> Order
comparator a b =
  let
    parts = zipParts (splitToParts a) (splitToParts b)
  in
    foldl process EQ parts


-- Sort versions according to rules of Semantic Versioning, in reverse order
sort : List Version -> List Version
sort list =
  reverse <| sortWith comparator list
