module Base.Search exposing (..)

import List exposing (append, filter, foldl, map)
import Regex
import String exposing
  ( contains, dropLeft, dropRight, endsWith
  , isEmpty, join, left, startsWith, words
  )


type alias SearchData =
  { name : String
  , tags : List String
  }

searchAll : SearchData
searchAll =
  { name = ""
  , tags = []
  }

searchByName : String -> SearchData
searchByName str =
  { searchAll
  | name = str
  }

searchByTag : String -> SearchData
searchByTag tag =
  { searchAll
  | tags = [ tag ]
  }
searchByTags : List String -> SearchData
searchByTags tags =
  { searchAll
  | tags = tags
  }


tagToken : String -> String
tagToken tag =
  if isEmpty tag then ""
  else "#" ++ ( if contains " " tag then "\"" ++ tag ++ "\"" else tag )

-- Serialize search query to local URL
searchQuery : SearchData -> String
searchQuery data =
  let
    tags = map tagToken data.tags
    tokens = data.name :: tags
  in
    join " " ( filter (not << isEmpty) tokens )


prefix : String -> String -> String
prefix token prefix =
  if isEmpty token then "" else prefix ++ token

searchApiPath : SearchData -> String
searchApiPath data =
  let
    tags = map ( \tag -> prefix tag "tags=" ) data.tags
    name = prefix data.name "name="
    tokens = name :: tags
    query = join "&" (filter (not << isEmpty) tokens)
  in
    if isEmpty query then "" else "?" ++ query


-- Parse local search URL back to search data
searchData : String -> SearchData
searchData query =
  let
    tokens = words query
  in
    foldl
      ( \token (data, cache) ->
        if isEmpty cache then
          case left 1 token of
            "#" ->
              let
                part = dropLeft 1 token
              in
                if startsWith "\"" part then
                  let
                    part2 = dropLeft 1 part
                  in
                    if endsWith "\"" part2 then
                      ( { data | tags = (cache ++ " " ++ (dropRight 1 part2)) :: data.tags }, "")
                    else
                      ( data, part2 )
                else
                  ( { data | tags = part :: data.tags }, "" )
            "@" -> ( data, "" )  -- TODO: add search by author
            _ -> ( { data | name = token }, "" )
        else
          if endsWith "\"" token then
            ( { data | tags = (cache ++ " " ++ (dropRight 1 token)) :: data.tags }, "")
          else
            ( data, cache ++ " " ++ token )
      )
      (searchAll, "")
      tokens
      |> fst
