module User.Update exposing (..)

import Base.Api as Api
import Base.Config as Config
import Base.Messages as Outer
import Base.Search as Search
import Base.Tools as Tools exposing ((~), wrapMsg)
import Base.Url as Url
import User.Messages exposing (Msg(..))
import User.Models exposing (User, UserData, emptyUser)


update : Msg -> UserData -> ( UserData, Cmd Msg, List Outer.Msg )
update message data =
  case message of
    NoOp ->
      ( data, Cmd.none, [] )
    ErrorOccurred message ->
      { data
        | loggedin = False
        , loading = False
      } ! [] ~ [ Outer.ErrorOccurred message ]

    -- Network
    LogIn nickname password ->
      { data | loading = True } ! [ Api.login nickname password LoggedIn ] ~ []
    LoggedIn (Ok _) ->
      { data
        | loggedin = True
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
      { data | loading = False, loggedin = False, user = emptyUser } ! [] ~ [ Outer.Navigate Url.auth ]
    LoggedOut (Err _) ->
      data
      ! [ wrapMsg (ErrorOccurred "For some reason, you can't close your session. Maybe you stay a little longer?") ]
      ~ []

    FetchUser name ->
      data ! [ Api.fetchUser name UserFetched ] ~ []
    UserFetched (Ok user) ->
      { data | user = user } ! [] ~ []
    UserFetched (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch user data!") ] ~ []

    CheckSession ->
      data ! [ Api.checkSession SessionChecked ] ~ []
    SessionChecked (Ok profile) ->
      let user = data.user
      in { data
             | user = { user | nickname = profile.nickname }
             , loggedin = profile.loggedin
             , apiVersion = profile.apiVersion
         } ! ( if profile.loggedin then [ wrapMsg <| FetchUser profile.nickname ] else [] ) ~ []
    SessionChecked (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to check user session data!") ] ~ []

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

    PackagesFetched (Ok packages) ->
      { data | packages = packages, loading = False } ! [] ~ []
    PackagesFetched (Err _) ->
      data ! [ wrapMsg (ErrorOccurred "Failed to fetch the list of your packages!") ] ~ []

    -- Navigation callbacks
    GoToAuth ->
      { data | validate = False } ! [] ~ []

    GoToRegister ->
      { data | validate = False } ! [] ~ []

    GoToProfile ->
      { data | loading = True }
      ! [ Api.fetchPackages (Search.searchByAuthor data.user.nickname) PackagesFetched ] ~ []

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

    InputKey key ->
      data ! (
        if key == Config.enterKey then [ wrapMsg <| LogIn data.user.nickname data.user.password ]
        else []
      ) ~ []
