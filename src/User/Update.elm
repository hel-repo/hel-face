module User.Update exposing (..)

import Task

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
      { data | loading = True } ! [ Api.login nickname password ErrorOccurred LoggedIn ] ~ []
    LoggedIn ->
      { data
        | loggedin = True
        , loading = False
      }
      ! [ wrapMsg <| FetchUser data.user.nickname ]
      ~ [ Outer.Navigate Url.packages ]

    LogOut ->
      { data | loading = True } ! [ Api.logout ErrorOccurred LoggedOut ] ~ []
    LoggedOut ->
      { data | loading = False, loggedin = False, user = emptyUser } ! [] ~ [ Outer.Navigate Url.auth ]

    FetchUser name ->
      data ! [ Api.fetchUser name ErrorOccurred UserFetched ] ~ []
    UserFetched user ->
      { data | user = user } ! [] ~ []

    CheckSession ->
      data ! [ Api.checkSession ErrorOccurred SessionChecked ] ~ []
    SessionChecked profile ->
      let user = data.user
      in { data | user = { user | nickname = profile.nickname }, loggedin = profile.loggedin }
         ! ( if profile.loggedin then [ wrapMsg <| FetchUser profile.nickname ] else [] ) ~ []

    Register user ->
      { data | loading = True } ! [ Api.register user ErrorOccurred Registered ] ~ []
    Registered ->
      { data | loading = False }
      ! []
      ~ [ Outer.Navigate Url.auth, Outer.SomethingOccurred "You have registered successfully!" ]

    PackagesFetched packages ->
      { data | packages = packages, loading = False } ! [] ~ []

    -- Navigation callbacks
    GoToAuth ->
      data ! [] ~ []

    GoToRegister ->
      data ! [] ~ []

    GoToProfile ->
      { data | loading = True }
      ! [ Api.fetchPackages (Search.searchByAuthor data.user.nickname) ErrorOccurred PackagesFetched ] ~ []

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
