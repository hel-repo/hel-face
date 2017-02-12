module Base.Helpers.Search exposing (
  prefixedWord,
  PackageQuery, PackagePage,
  queryPkgAll, queryPkgByAuthor, queryPkgByAuthors, queryPkgByName,
  queryPkgByOwner, queryPkgByOwners, queryPkgByTag, queryPkgByTags,
  packageQueryToPhrase, phraseToPackageQuery)

import List
import Combine exposing (..)

import Base.Models.Package exposing (Package)
import Base.Models.Network exposing (Page)


{-| This module provides "search query" models, and various converters for them

## Query
This is an internal model, representing page filters.
It can contain several fields, like `name`, `author` etc.

## Phrase
This is a string used for search box in the header.
It is formatted using simple markup syntax:
 * `word`    - search by word in name or description
 * `#tag`    - search by content tag
 * `@author` - search by author
Each token can consist of several words, if written inside of quotes:
`@"Some Author"`, `"two words"` etc.

 -}




-- Query models
------------------------------------------------------------------------------------------------------------------------
type alias PackageQuery =
  { names : List String
  , tags : List String
  , authors : List String
  , owners : List String
  }

queryPkgAll : PackageQuery
queryPkgAll =
  { names = []
  , tags = []
  , authors = []
  , owners = []
  }

-- Additional modifiers, can be chained
queryPkgByName : PackageQuery -> String -> PackageQuery
queryPkgByName query str =
  { query | names = str :: query.names }

queryPkgByTag : PackageQuery -> String -> PackageQuery
queryPkgByTag query tag =
  { query | tags = tag :: query.tags }
queryPkgByTags : PackageQuery -> List String -> PackageQuery
queryPkgByTags query tags =
  { query | tags = List.append tags query.tags }

queryPkgByAuthor : PackageQuery -> String -> PackageQuery
queryPkgByAuthor query author =
  { query | authors = author :: query.authors }
queryPkgByAuthors : PackageQuery -> List String -> PackageQuery
queryPkgByAuthors query authors =
  { query | authors = List.append authors query.authors }

queryPkgByOwner : PackageQuery -> String -> PackageQuery
queryPkgByOwner query owner =
  { query | owners = owner :: query.owners }
queryPkgByOwners : PackageQuery -> List String -> PackageQuery
queryPkgByOwners query owners =
  { query | owners = List.append owners query.owners }

type alias PackagePage = Page Package PackageQuery


-- Query to phrase
------------------------------------------------------------------------------------------------------------------------
quote : String -> String
quote str =
  if String.contains " " str then "\"" ++ str ++ "\"" else str

prefixedWord : String -> String -> String
prefixedWord prefix word =
  if String.isEmpty word then "" else prefix ++ word


packageQueryToPhrase : PackageQuery -> String
packageQueryToPhrase data =
  let
    names = List.map quote data.names
    tags = List.map ( (prefixedWord "#") << quote ) data.tags
    authors = List.map ( (prefixedWord "@") << quote ) data.authors
    tokens = List.concat [names, tags, authors]
  in
    String.join " " ( List.filter (not << String.isEmpty) tokens )


-- Phrase to query
------------------------------------------------------------------------------------------------------------------------
type Token = Name String | Tag String | Author String

word : Parser s String
word = regex "\\S+"

quoted : Parser s String
quoted = regex "\"[^\"]*\""

value : Parser s String
value = (map (String.dropLeft 1 << String.dropRight 1) quoted) <|> word

prefixed : String -> Parser s String
prefixed prefix = (string prefix) |> andThen (always value)

separator : Parser s String
separator = regex "\\s+"


phraseToPackageQuery : String -> PackageQuery
phraseToPackageQuery query =
  let
    parser = sepBy separator
      <| choice
           [ Tag <$> (prefixed "#")
           , Author <$> (prefixed "@")
           , Name <$> value
           ]
    tokens = case parse parser query of
      Ok(_, _, result) -> result
      Err(_, _, _) -> []
  in
    List.foldl
      ( \token data ->
          case token of
            Tag tag -> { data | tags = tag :: data.tags }
            Author author -> { data | authors = author :: data.authors }
            Name name -> { data | names = name :: data.names }
      )
      queryPkgAll
      tokens
