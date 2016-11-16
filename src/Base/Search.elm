module Base.Search exposing (..)

import List
import String exposing ( contains, dropLeft, dropRight, isEmpty, join )

import Combine exposing (..)


type alias SearchData =
  { names : List String
  , tags : List String
  , authors : List String
  }

searchAll : SearchData
searchAll =
  { names = []
  , tags = []
  , authors = []
  }

searchByName : String -> SearchData
searchByName str =
  { searchAll
  | names = [ str ]
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

searchByAuthor : String -> SearchData
searchByAuthor author =
  { searchAll
  | authors = [ author ]
  }
searchByAuthors : List String -> SearchData
searchByAuthors authors =
  { searchAll
  | authors = authors
  }


-- Serialize search query to local URL
token : String -> String
token str =
  if contains " " str then "\"" ++ str ++ "\"" else str

prefixedToken : String -> String -> String
prefixedToken prefix str =
  if isEmpty str then ""
  else prefix ++ (token str)

searchQuery : SearchData -> String
searchQuery data =
  let
    names = List.map token data.names
    tags = List.map (prefixedToken "#") data.tags
    authors = List.map (prefixedToken "@") data.authors
    tokens = names `List.append` tags `List.append` authors
  in
    join " " ( List.filter (not << isEmpty) tokens )


-- Generate API search query
prefixedPart : String -> String -> String
prefixedPart prefix token =
  if isEmpty token then "" else prefix ++ token

searchApiPath : SearchData -> String
searchApiPath data =
  let
    names = List.map ( prefixedPart "name=" ) data.names
    tags = List.map ( prefixedPart "tags=" ) data.tags
    authors = List.map ( prefixedPart "authors=" ) data.authors
    tokens = names `List.append` tags `List.append` authors
    query = join "&" (List.filter (not << isEmpty) tokens)
  in
    if isEmpty query then "" else "?" ++ query


-- Parse local search URL back to search data
type Token = Name String | Tag String | Author String

word : Parser String
word = regex "\\S+"

quoted : Parser String
quoted = regex "\"[^\"]*\""

value : Parser String
value = (map (dropLeft 1 << dropRight 1) quoted) `or` word

prefixed : String -> Parser String
prefixed prefix = (string prefix) `andThen` (always value)

separator : Parser String
separator = regex "\\s+"

searchData : String -> SearchData
searchData query =
  let
    (tokens, _) = parse
      ( sepBy separator ( choice
        [ Tag `map` (prefixed "#")
        , Author `map` (prefixed "@")
        , Name `map` value
        ] ) )
      query
  in
    List.foldl
      ( \token data ->
          case token of
            Tag tag -> { data | tags = tag :: data.tags }
            Author author -> { data | authors = author :: data.authors }
            Name name -> { data | names = name :: data.names }
      )
      searchAll
      <| Result.withDefault [] tokens
