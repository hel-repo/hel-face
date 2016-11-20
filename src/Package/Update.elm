module Package.Update exposing (..)

import List exposing (drop, filter, length, map2, member, reverse, sortBy, take)
import String exposing (isEmpty)
import Task exposing (Task)

import Base.Api as Api
import Base.Config as Config
import Base.Messages as Outer
import Base.Search exposing (SearchData, searchAll, searchApiPath)
import Base.Semver as Semver
import Base.Tools as Tools exposing ((~), (!!))
import Package.Messages exposing (Msg(..))
import Package.Models exposing (..)


wrapMsg : Msg -> Cmd Msg
wrapMsg msg =
  Task.perform (always msg) (always msg) (Task.succeed ())

add : List a -> a -> List a
add list item =
  if member item list then
    list
  else
    item :: list

remove : List a -> a -> List a
remove list item =
  filter (\a -> a /= item) list

removeByIndex : Int -> List a -> List a
removeByIndex i xs =
  (take i xs) ++ (drop (i+1) xs)

updateItem : List a -> (a -> a) -> Int -> List a
updateItem list processor index =
  map2
    ( \i item -> if i == index then processor item else item )
    [0..(length list)]
    list


update : Msg -> PackageData -> ( PackageData, Cmd Msg, List Outer.Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none, [] )
    ErrorOccurred message ->
      { data
        | loading = False
        , packages = []
        , package = emptyPackage
      } ! [] ~ [ Outer.ErrorOccurred message ]

    -- Network
    FetchPackages searchData ->
      { data | loading = True } ! [ Api.fetchPackages searchData ErrorOccurred PackagesFetched ] ~ []
    PackagesFetched packages ->
      { data
        | packages = packages
        , loading = False
      } ! [] ~ []

    FetchPackage name ->
      { data | loading = True } ! [ Api.fetchPackage name ErrorOccurred PackageFetched ] ~ []
    PackageFetched package ->
      let
        sorted = { package | versions = Semver.sort package.versions }
      in
        { data
          | package = sorted
          , oldPackage = sorted
          , version = 0
          , loading = False
        } ! [] ~ []

    SavePackage package ->
      { data | loading = True }
      ! [ if not <| isEmpty data.oldPackage.name then
            Api.savePackage package data.oldPackage ErrorOccurred PackageSaved
          else
            Api.createPackage package ErrorOccurred PackageSaved
        ]
      ~ []
    PackageSaved response ->
      { data | loading = False }
      ! []
      ~ [ Outer.RoutePackageDetails data.package.name, Outer.SomethingOccurred "Package was succesfully saved!" ]

    RemovePackage name ->
      { data | loading = True } ! [ Api.removePackage name ErrorOccurred PackageRemoved ] ~ []
    PackageRemoved response ->
      { data | loading = False }
      ! []
      ~ [ Outer.RoutePackageList searchAll, Outer.SomethingOccurred "Package was succesfully removed!" ]

    -- Navigation
    GoToPackageList searchData ->
      data ! [ wrapMsg (FetchPackages searchData) ] ~ []
    GoToPackageDetails name ->
      data ! [ wrapMsg (FetchPackage name) ] ~ []
    GoToPackageEdit name ->
      if not <| isEmpty name then
        data ! [ wrapMsg (FetchPackage name) ] ~ []
      else
        let newPackage = { emptyPackage | owners = [data.username] }
        in { data | package = newPackage, oldPackage = newPackage } ! [] ~ []

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
    AddVersion ->
      let package = data.package
      in { data | version = 0, package = { package | versions = emptyVersion :: package.versions } } ! [] ~ []
    RemoveVersion ->
      let package = data.package
      in
        case package.versions !! data.version of
          Just selected ->
            { data
            | package = { package | versions = filter (\v -> v.version /= selected.version) package.versions }
            } ! [] ~ []
          Nothing -> data ! [] ~ []
    InputVersion num ->
      let
        package = data.package
        versions = updateItem package.versions (\v -> { v | version = num }) data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    InputChanges changes ->
      let
        package = data.package
        versions = updateItem package.versions (\v -> { v | changes = changes }) data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    InputFilePath index path ->
      let
        package = data.package
        versions = updateItem
          package.versions
          (\v -> { v | files = updateItem v.files (\f -> { f | dir = path } ) index })
          data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    InputFileName index name ->
      let
        package = data.package
        versions = updateItem
          package.versions
          (\v -> { v | files = updateItem v.files (\f -> { f | name = name } ) index })
          data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    InputFileUrl index url ->
      let
        package = data.package
        versions = updateItem
          package.versions
          (\v -> { v | files = updateItem v.files (\f -> { f | url = url } ) index })
          data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    AddFile ->
      let
        package = data.package
        versions = updateItem package.versions (\v -> { v | files = emptyFile :: v.files }) data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    RemoveFile index ->
      let
        package = data.package
        versions = updateItem package.versions (\v -> { v | files = removeByIndex index v.files }) data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    InputDependencyName index name ->
      let
        package = data.package
        versions = updateItem
          package.versions
          (\v -> { v | depends = updateItem v.depends (\d -> { d | name = name } ) index })
          data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    InputDependencyVersion index num ->
      let
        package = data.package
        versions = updateItem
          package.versions
          (\v -> { v | depends = updateItem v.depends (\d -> { d | version = num } ) index })
          data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    AddDependency ->
      let
        package = data.package
        versions = updateItem package.versions (\v -> { v | depends = emptyDependency :: v.depends }) data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    RemoveDependency index ->
      let
        package = data.package
        versions = updateItem package.versions (\v -> { v | depends = removeByIndex index v.depends }) data.version
      in { data | package = { package | versions = versions } } ! [] ~ []
    InputScreenshotUrl index url ->
      let
        package = data.package
        screenshots = updateItem package.screenshots (\s -> { s | url = url }) index
      in { data | package = { package | screenshots = screenshots } } ! [] ~ []
    InputScreenshotDescription index description ->
      let
        package = data.package
        screenshots = updateItem package.screenshots (\s -> { s | description = description }) index
      in { data | package = { package | screenshots = screenshots } } ! [] ~ []
    AddScreenshot ->
      let package = data.package
      in { data | package = { package | screenshots = emptyScreenshot :: package.screenshots } } ! [] ~ []
    RemoveScreenshot index ->
      let package = data.package
      in { data | package = { package | screenshots = removeByIndex index package.screenshots } } ! [] ~ []

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
