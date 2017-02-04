module Package.Update exposing (..)

import List exposing (drop, filter, length, map2, member, reverse, sortBy, take)
import String exposing (isEmpty)

import Base.Api as Api
import Base.Config as Config
import Base.Messages as Outer
import Base.Models exposing (emptyPackage, emptyVersion, emptyDependency, emptyFile, emptyScreenshot)
import Base.Ports exposing (title)
import Base.Search exposing (SearchData, searchAll, searchApiPath)
import Base.Semver as Semver
import Base.Tools as Tools exposing ((~), (!!), wrapMsg)
import Package.Messages exposing (Msg(..))
import Package.Models exposing (..)


updateItem : List a -> (a -> a) -> Int -> List a
updateItem list processor index =
  map2
    ( \i item -> if i == index then processor item else item )
    (List.range 0 <| length list)
    list


update : Msg -> PackageData -> ( PackageData, Cmd Msg, List Outer.Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none, [] )
    ErrorOccurred message ->
      { data | loading = False } ! [] ~ [ Outer.ErrorOccurred message ]

    -- Network
    FetchPackages searchData ->
      { data | loading = True, searchData = searchData } ! [ Api.fetchPackagesPage searchData PackagesFetched ] ~ []
    PackagesFetched (Ok page) ->
      { data
        | packages = page
        , loading = False
      } ! [] ~ []
    PackagesFetched (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch packages!") ] ~ []

    NextPage ->
      if (data.packages.total - data.packages.offset) > Config.pageSize then
        let
          searchData = data.searchData
          nextPageData = { searchData | offset = searchData.offset + Config.pageSize }
        in
          data ! [ wrapMsg <| FetchPackages nextPageData ] ~ []
      else data ! [] ~ []

    PreviousPage ->
      if data.packages.offset > 0 then
        let
          searchData = data.searchData
          prevPageData = { searchData | offset = max 0 <| searchData.offset - Config.pageSize }
        in
          data ! [ wrapMsg <| FetchPackages prevPageData ] ~ []
      else data ! [] ~ []

    FetchPackage name ->
      { data | loading = True } ! [ Api.fetchPackage name PackageFetched ] ~ []
    PackageFetched (Ok package) ->
      let
        sorted = { package | versions = Semver.sort package.versions }
      in
        { data
          | package = sorted
          , oldPackage = sorted
          , version = 0
          , loading = False
        } ! [] ~ []
    PackageFetched (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch package!") ] ~ []

    SavePackage package ->
      { data | loading = True }
      ! [ if not <| isEmpty data.oldPackage.name then
            Api.savePackage package data.oldPackage PackageSaved
          else
            Api.createPackage package PackageSaved
        ]
      ~ []
    PackageSaved (Ok _) ->
      { data | loading = False }
      ! []
      ~ [ Outer.RoutePackageDetails data.package.name, Outer.SomethingOccurred "Package was succesfully saved!" ]
    PackageSaved (Err _) ->
      { data | validate = True } ! [ wrapMsg (ErrorOccurred "Failed to save the package!") ] ~ []

    RemovePackage name ->
      { data | loading = True } ! [ Api.removePackage name PackageRemoved ] ~ []
    PackageRemoved (Ok _) ->
      { data | loading = False }
      ! []
      ~ [ Outer.RoutePackageList searchAll, Outer.SomethingOccurred "Package was succesfully removed!" ]
    PackageRemoved (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to remove the package!") ] ~ []

    -- Navigation
    GoToPackageList searchData ->
      data ! [ title "HEL Repository", wrapMsg (FetchPackages searchData) ] ~ []
    GoToPackageDetails name ->
      { data | screenshot = 0, screenshotLoading = True }
      ! [ title <| "HEL: " ++ name, wrapMsg (FetchPackage name) ] ~ []
    GoToPackageEdit name ->
      if not <| isEmpty name then
        { data | validate = False }
        ! [ title <| "Edit: " ++ name, wrapMsg (FetchPackage name) ] ~ []
      else
        let newPackage = { emptyPackage | owners = [data.session.user.nickname] }
        in { data | package = newPackage, oldPackage = newPackage, validate = False }
           ! [ title "HEL: new package" ] ~ []

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
      in { data | package = { package | owners = Tools.remove package.owners owner } } ! [] ~ []
    InputAuthor author ->
      let tags = data.tags
      in { data | tags = Tags Author tags.owner author tags.content } ! [] ~ []
    RemoveAuthor author ->
      let package = data.package
      in { data | package = { package | authors = Tools.remove package.authors author } } ! [] ~ []
    InputContent content ->
      let tags = data.tags
      in { data | tags = Tags Content tags.owner tags.author content } ! [] ~ []
    RemoveContent content ->
      let package = data.package
      in { data | package = { package | tags = Tools.remove package.tags content } } ! [] ~ []
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
        versions = updateItem
          package.versions
          (\v -> { v | files = Tools.removeByIndex index v.files })
          data.version
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
        versions = updateItem
          package.versions
          (\v -> { v | depends = Tools.removeByIndex index v.depends })
          data.version
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
      in { data | package = { package | screenshots = Tools.removeByIndex index package.screenshots } } ! [] ~ []

    InputKey key ->
      if key == Config.enterKey then
        let
          package = data.package
        in
          ( case data.tags.active of
              Owner ->
                let owners = Tools.add package.owners data.tags.owner
                in { data | package = { package | owners = owners } } ! [ wrapMsg (InputOwner "") ]
              Author ->
                let authors = Tools.add package.authors data.tags.author
                in { data | package = { package | authors = authors } } ! [ wrapMsg (InputAuthor "") ]
              Content ->
                let content = Tools.add package.tags data.tags.content
                in { data | package = { package | tags = content } } ! [ wrapMsg (InputContent "") ]
          ) ~ []
      else
        data ! [] ~ []

    -- Other
    SharePackage name ->
      { data | share = (if name /= data.share then name else "") } ! [] ~ []

    PreviousScreenshot ->
      if data.screenshot > 0 then
        { data | screenshot = data.screenshot - 1, screenshotLoading = True } ! [] ~ []
      else
        data ! [] ~ []

    NextScreenshot ->
      if data.screenshot < (List.length data.package.screenshots - 1) then
        { data | screenshot = data.screenshot + 1, screenshotLoading = True } ! [] ~ []
      else
        data ! [] ~ []

    ScreenshotLoaded ->
      { data | screenshotLoading = False } ! [] ~ []
