module User.Update exposing (..)

import Base.Api as Api
import Base.Config as Config
import Base.Messages as Outer
import Base.Models exposing (User, emptyUser)
import Base.Search as Search
import Base.Tools as Tools exposing ((~), wrapMsg)
import Base.Url as Url
import User.Messages exposing (Msg(..))
import User.Models exposing (UserData, Page(..))


update : Msg -> UserData -> ( UserData, Cmd Msg, List Outer.Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none, [] )
    ErrorOccurred message ->
      let session = data.session
      in
        { data
          | session = { session | loggedin = False }
          , loading = False
        } ! [] ~ [ Outer.ErrorOccurred message ]

    -- Network
    LogIn nickname password ->
      { data | loading = True } ! [ Api.login nickname password LoggedIn ] ~ []
    LoggedIn (Ok _) ->
      let session = data.session
      in
        { data
          | session = { session | loggedin = True }
          , loading = False
        }
        ! [ wrapMsg <| FetchUser data.user.nickname ]
        ~ [ Outer.Navigate Url.packages ]
    LoggedIn (Err _) ->
      { data | validate = True }
      ! [ wrapMsg (ErrorOccurred "Looks like either your nickname or password were incorrect. Wanna try again?") ]
      ~ []

    LogOut ->
      { data | loading = True } ! [ Api.logout LoggedOut ] ~ []
    LoggedOut (Ok _) ->
      let session = data.session
      in
        { data | loading = False, session = { session | loggedin = False }, user = emptyUser }
        ! [] ~ [ Outer.Navigate Url.auth ]
    LoggedOut (Err _) ->
      data
      ! [ wrapMsg (ErrorOccurred "For some reason, you can't close your session. Maybe you stay a little longer?") ]
      ~ []

    FetchUser name ->
      data ! [ Api.fetchUser name UserFetched ] ~ []
    UserFetched (Ok user) ->
      { data | user = user, loading = False } ! [] ~ []
    UserFetched (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch user data!") ] ~ []

    FetchUsers ->
      data ! [ Api.fetchUsers UsersFetched ] ~ []
    UsersFetched (Ok users) ->
      { data | users = users, loading = False } ! [] ~ []
    UsersFetched (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch user list!") ] ~ []

    Register user ->
      { data | loading = True } ! [ Api.register user Registered ] ~ []
    Registered (Ok _) ->
      { data | loading = False }
      ! []
      ~ [ Outer.Navigate Url.auth, Outer.SomethingOccurred "You have registered successfully!" ]
    Registered (Err _) ->
      { data | validate = True }
      ! [ wrapMsg (ErrorOccurred "Failed to register! Check the entered data, please.") ]
      ~ []

    SaveUser user ->
      data ! [] ~ []
    UserSaved (Ok _) ->
      data ! [] ~ [ Outer.Back, Outer.SomethingOccurred "User data was successfully saved!" ]
    UserSaved (Err _) ->
      data ! [ wrapMsg <| ErrorOccurred "Oops! Something went wrong, and user data wasn't saved!" ] ~ []

    PackagesFetched (Ok packages) ->
      { data | packages = packages, loading = False } ! [] ~ []
    PackagesFetched (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch the list of your packages!") ] ~ []

    -- Navigation callbacks
    GoToAuth ->
      { data | validate = False, page = Auth } ! [] ~ []

    GoToRegister ->
      { data | validate = False } ! [] ~ []

    GoToProfile nickname ->
      if String.isEmpty nickname then
        { data | loading = True, user = data.session.user }
        ! [ Api.fetchPackages (Search.searchByAuthor data.session.user.nickname) PackagesFetched ] ~ []
      else
        { data | loading = True }
        ! [ Api.fetchPackages (Search.searchByAuthor nickname) PackagesFetched
          , wrapMsg <| FetchUser nickname
          ] ~ []

    GoToUserList ->
      data ! [ wrapMsg FetchUsers ] ~ []

    GoToUserEdit nickname ->
      { data | loading = True, validate = False, page = Edit }
      ! [ wrapMsg <| FetchUser (if String.isEmpty nickname then data.session.user.nickname else nickname) ]
      ~ []

    GoToAbout ->
      data ! [] ~ []

    -- Other
    InputNickname nickname ->
      let user = data.user
      in { data | user = { user | nickname = nickname } } ! [] ~ []
    InputPassword password ->
      let user = data.user
      in { data | user = { user | password = password } } ! [] ~ []
    InputRetryPassword password ->
      let user = data.user
      in { data | user = { user | retryPassword = password } } ! [] ~ []
    InputEmail email ->
      let user = data.user
      in { data | user = { user | email = email } } ! [] ~ []
    InputGroup group ->
      { data | groupTag = group } ! [] ~ []
    RemoveGroup group ->
      let user = data.user
      in { data | user = { user | groups = Tools.remove user.groups group } } ! [] ~ []

    InputKey key ->
      if key == Config.enterKey then
        case data.page of
          Auth ->
            data ! [ wrapMsg <| LogIn data.user.nickname data.user.password ] ~ []
          Edit ->
            let user = data.user
            in { data | user = { user | groups = Tools.add user.groups data.groupTag }, groupTag = "" } ! [] ~ []
          _ ->
            data ! [] ~ []
      else
        data ! [] ~ []
