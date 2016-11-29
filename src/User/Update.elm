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
      let
        oldSession = data.session
        session = { oldSession | loggedin = True }
      in
        { data
          | session = session
          , loading = False
        }
        ! [ wrapMsg <| FetchUser True data.user.nickname ]
        ~ [ Outer.Navigate Url.packages, Outer.UpdateSession session ]
    LoggedIn (Err _) ->
      { data | validate = True }
      ! [ wrapMsg (ErrorOccurred "Looks like either your nickname or password were incorrect. Wanna try again?") ]
      ~ []

    LogOut ->
      { data | loading = True } ! [ Api.logout LoggedOut ] ~ []
    LoggedOut (Ok _) ->
      let
        oldSession = data.session
        session = { oldSession | loggedin = False, user = emptyUser }
      in
        { data | loading = False, session = session }
        ! [] ~ [ Outer.Navigate Url.auth, Outer.UpdateSession session ]
    LoggedOut (Err _) ->
      data
      ! [ wrapMsg (ErrorOccurred "For some reason, you can't close your session. Maybe you stay a little longer?") ]
      ~ []

    FetchUser sessionFetch name ->
      data ! [ Api.fetchUser name (UserFetched sessionFetch) ] ~ []
    UserFetched sessionFetch (Ok user) ->
      { data | user = user, loading = False, oldNickname = user.nickname }
      ! []
      ~ ( if sessionFetch then
            let session = data.session
            in [ Outer.UpdateSession { session | user = user } ]
          else []
        )
    UserFetched _ (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch user data!") ] ~ []

    FetchUsers group ->
      { data | loading = True }
      ! [ if String.isEmpty group then Api.fetchUsers UsersFetched else Api.fetchUsersByGroup group UsersFetched ]
      ~ []
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
      { data | loading = True } ! [ Api.saveUser user data.oldNickname UserSaved ] ~ []
    UserSaved (Ok _) ->
      { data | loading = False } ! [] ~ [ Outer.Back, Outer.SomethingOccurred "User data was successfully saved!" ]
    UserSaved (Err _) ->
      { data | validate = True } ! [ wrapMsg <| ErrorOccurred "Oops! Something went wrong, and user data wasn't saved!" ] ~ []

    RemoveUser nickname ->
      { data | loading = True } ! [ Api.removeUser nickname UserRemoved ] ~ []
    UserRemoved (Ok _) ->
      { data | loading = False } ! [] ~ [ Outer.Back, Outer.SomethingOccurred "User account was successfully removed!" ]
    UserRemoved (Err _) ->
      data ! [ wrapMsg <| ErrorOccurred "Oops! Something went wrong, and user account wasn't removed!" ] ~ []

    PackagesFetched (Ok packages) ->
      { data | packages = packages, loading = False } ! [] ~ []
    PackagesFetched (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch the list of your packages!") ] ~ []

    -- Navigation callbacks
    GoToAuth ->
      { data | loading = False, validate = False, page = Auth } ! [] ~ []

    GoToRegister ->
      { data | loading = False, validate = False } ! [] ~ []

    GoToProfile nickname ->
      if String.isEmpty nickname then
        if String.isEmpty data.session.user.nickname then
          { data | loading = True } ! [] ~ [ Outer.Navigate Url.auth ]
        else
          { data | loading = True, user = data.session.user }
          ! [ Api.fetchPackages (Search.searchByOwner data.session.user.nickname) PackagesFetched ] ~ []
      else
        { data | loading = True }
        ! [ Api.fetchPackages (Search.searchByOwner nickname) PackagesFetched
          , wrapMsg <| FetchUser False nickname
          ] ~ []

    GoToUserList group ->
      data ! [ wrapMsg <| FetchUsers group ] ~ []

    GoToUserEdit nickname ->
      { data | loading = True, validate = False, page = Edit }
      ! [ wrapMsg <| FetchUser False (if String.isEmpty nickname then data.session.user.nickname else nickname) ]
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
