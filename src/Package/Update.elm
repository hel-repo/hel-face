module Package.Update exposing (..)

import Http
import List exposing (member, filter, reverse, sortBy)
import String exposing (isEmpty)
import Task exposing (Task)

import Base.Config as Config
import Base.Http exposing (..)
import Base.Messages as Outer
import Base.Tools as Tools exposing ((~))
import Package.Encoders exposing (packageEncoder)
import Package.Messages exposing (Msg(..))
import Package.Models exposing (..)
import Package.Decoders exposing (singlePackageDecoder, packagesDecoder)


wrapMsg : Msg -> Cmd Msg
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())

lookupPackage : String -> Cmd Msg
lookupPackage name =
  Http.get singlePackageDecoder (Config.apiHost ++ "packages/" ++ name)
    |> Task.mapError toString
    |> Task.perform ErrorOccurred PackageFetched

lookupPackages : SearchData -> Cmd Msg
lookupPackages data =
  Http.get packagesDecoder
    ( Config.apiHost
      ++ "packages"
      ++ (if isEmpty data.name then "" else "?name=" ++ data.name)
    )
    |> Task.mapError toString
    |> Task.perform ErrorOccurred PackagesFetched

savePackage : Package -> Cmd Msg
savePackage package =
  let
    name = if isEmpty package.oldName then package.name else package.oldName
  in
    patch'
      ( Config.apiHost ++ "packages/" ++ name )
      ( packageEncoder package )
      |> Task.mapError toString
      |> Task.perform ErrorOccurred PackageSaved


add : List a -> a -> List a
add list item =
  if member item list then
    list
  else
    item :: list

remove : List a -> a -> List a
remove list item =
  filter (\a -> a /= item) list


update : Msg -> PackageData -> ( PackageData, Cmd Msg, List Outer.Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none, [] )
    ErrorOccurred message ->
      { data
        | loading = False
        , packages = []
      } ! [] ~ [ Outer.ErrorOccurred message ]

    -- Network
    FetchPackages searchData ->
      { data | loading = True } ! [ lookupPackages searchData ] ~ []
    PackagesFetched packages ->
      { data
        | packages = packages
        , loading = False
      } ! [] ~ []

    FetchPackage name ->
      { data | loading = True } ! [ lookupPackage name ] ~ []
    PackageFetched package ->
      let
        versions = reverse <| sortBy .version package.versions
      in
        { data
          | package = { package | versions = versions }
          , version = 0
          , loading = False
        } ! [] ~ []

    SavePackage package ->
      data ! [ savePackage package ] ~ []
    PackageSaved response ->
      data ! [] ~ [ Outer.SomethingOccurred "Package was succesfully saved!" ]

    -- Navigation
    GoToPackageList searchData ->
      data ! [ wrapMsg (FetchPackages searchData) ] ~ []
    GoToPackageDetails name ->
      data ! [ wrapMsg (FetchPackage name) ] ~ []
    GoToPackageEdit name ->
      if not <| isEmpty name then
        data ! [ wrapMsg (FetchPackage name) ] ~ []
      else
        { data | package = emptyPackage } ! [] ~ []

    GoToVersion num ->
      { data | version = num } ! [] ~ []

    -- Input
    InputName name ->
      let package = data.package
      in { data | package = { package | name = name } } ! [] ~ []
    InputLicense license ->
      let package = data.package
      in { data | package = { package | license = license } } ! [] ~ []
    InputDescription desc ->
      let package = data.package
      in { data | package = { package | description = desc } } ! [] ~ []
    InputShortDescription desc ->
      let package = data.package
      in { data | package = { package | shortDescription = desc } } ! [] ~ []
    InputOwner owner ->
      let tags = data.tags
      in { data | tags = Tags Owner owner tags.author tags.content } ! [] ~ []
    RemoveOwner owner ->
      let package = data.package
      in { data | package = { package | owners = remove package.owners owner } } ! [] ~ []
    InputAuthor author ->
      let tags = data.tags
      in { data | tags = Tags Author tags.owner author tags.content } ! [] ~ []
    RemoveAuthor author ->
      let package = data.package
      in { data | package = { package | authors = remove package.authors author } } ! [] ~ []
    InputContent content ->
      let tags = data.tags
      in { data | tags = Tags Content tags.owner tags.author content } ! [] ~ []
    RemoveContent content ->
      let package = data.package
      in { data | package = { package | tags = remove package.tags content } } ! [] ~ []

    InputKey key ->
      if key == Config.enterKey then
        let
          package = data.package
        in
          ( case data.tags.active of
              Owner ->
                let owners = add package.owners data.tags.owner
                in { data | package = { package | owners = owners } } ! [ wrapMsg (InputOwner "") ]
              Author ->
                let authors = add package.authors data.tags.author
                in { data | package = { package | authors = authors } } ! [ wrapMsg (InputAuthor "") ]
              Content ->
                let content = add package.tags data.tags.content
                in { data | package = { package | tags = content } } ! [ wrapMsg (InputContent "") ]
          ) ~ []
      else
        data ! [] ~ []

    -- Other
    SharePackage name ->
      { data | share = (if name /= data.share then name else "") } ! [] ~ []
