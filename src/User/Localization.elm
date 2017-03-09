module User.Localization exposing (..)

import Dict exposing (Dict, fromList)


get : String -> Dict.Dict String String -> String
get lang resource =
  case (Dict.get lang resource) of
    Just string -> string
    Nothing -> ""


-- Auth
------------------------------------------------------------------------------------------------------------------------
authorization : Dict String String
authorization =
  fromList
    [ ("en", "Authorization")
    , ("ru", "Авторизация")
    ]

nickname : Dict String String
nickname =
  fromList
    [ ("en", "Nickname")
    , ("ru", "Никнейм")
    ]

cantBeEmpty : Dict String String
cantBeEmpty =
  fromList
    [ ("en", "Can't be empty")
    , ("ru", "Не может быть пустым")
    ]

password : Dict String String
password =
  fromList
    [ ("en", "Password")
    , ("ru", "Пароль")
    ]

login : Dict String String
login =
  fromList
    [ ("en", "log in")
    , ("ru", "войти")
    ]

or : Dict String String
or =
  fromList
    [ ("en", "or")
    , ("ru", "или")
    ]

register : Dict String String
register =
  fromList
    [ ("en", "register")
    , ("ru", "зарегистрироваться")
    ]


-- Edit
------------------------------------------------------------------------------------------------------------------------
cannotBeNameless : Dict String String
cannotBeNameless =
  fromList
    [ ("en", "User can not be nameless!")
    , ("ru", "Пользователь должен обладать ником!")
    ]

leaveEmpty : Dict String String
leaveEmpty =
  fromList
    [ ("en", "Leave this field empty, if you don't want to change the password.")
    , ("ru", "Оставьте это поле пустым, если вы не хотите изменять пароль.")
    ]

retryPassword : Dict String String
retryPassword =
  fromList
    [ ("en", "Retry password")
    , ("ru", "Повторите пароль")
    ]

doesNotMatch : Dict String String
doesNotMatch =
  fromList
    [ ("en", "Doesn't match password!")
    , ("ru", "Пароли не совпадают")
    ]

dependsOn : Dict String String
dependsOn =
  fromList
    [ ("en", "Depends on")
    , ("ru", "Зависит от")
    ]

toAddGroup : Dict String String
toAddGroup =
  fromList
    [ ("en", "To add a group, enter the name and then press Enter.")
    , ("ru", "Чтобы добавить группу, введите её название и нажмите Enter.")
    ]

userGroup : Dict String String
userGroup =
  fromList
    [ ("en", "User group")
    , ("ru", "Пользователь входит в группы")
    ]

save : Dict String String
save =
  fromList
    [ ("en", "Save")
    , ("ru", "Сохранить")
    ]

cancel : Dict String String
cancel =
  fromList
    [ ("en", "Cancel")
    , ("ru", "Отмена")
    ]


-- List
------------------------------------------------------------------------------------------------------------------------
edit : Dict String String
edit =
  fromList
    [ ("en", "Edit")
    , ("ru", "Редактировать")
    ]

delete : Dict String String
delete =
  fromList
    [ ("en", "Delete")
    , ("ru", "Удалить")
    ]

nothingFound : Dict String String
nothingFound =
  fromList
    [ ("en", "Nothing found!")
    , ("ru", "Ничего не найдено!")
    ]

noUsers : Dict String String
noUsers =
  fromList
    [ ("en", "No users was found by this query.")
    , ("ru", "По данному запросу не было найдено ни одного пользователя.")
    ]

checkSpelling : Dict String String
checkSpelling =
  fromList
    [ ("en", "Check the spelling, or try different request, please.")
    , ("ru", "Пожалуйста, проверьте правильность написания, или переформулируйте запрос.")
    ]

prevPage : Dict String String
prevPage =
  fromList
    [ ("en", "< Prev Page")
    , ("ru", "< Предыдущая")
    ]

nextPage : Dict String String
nextPage =
  fromList
    [ ("en", "Next Page >")
    , ("ru", "Следующая >")
    ]


-- Profile
------------------------------------------------------------------------------------------------------------------------
profile : Dict String String
profile =
  fromList
    [ ("en", "Profile")
    , ("ru", "Профиль")
    ]

groups : Dict String String
groups =
  fromList
    [ ("en", "Groups")
    , ("ru", "Группы")
    ]

youHaveNotAddedAnything : Dict String String
youHaveNotAddedAnything =
  fromList
    [ ("en", "You've not added any packages to this repository yet.")
    , ("ru", "Вы ещё не добавили в репозиторий ни одного пакета.")
    ]

thisUserHaveNotAddedAnything : Dict String String
thisUserHaveNotAddedAnything =
  fromList
    [ ("en", "This user have not added any packages to repository yet.")
    , ("ru", "Этот пользователь пока не добавил в репозиторий ни одного пакета.")
    ]

dashboard : Dict String String
dashboard =
  fromList
    [ ("en", "Dashboard")
    , ("ru", "Панель управления")
    ]

allUsers : Dict String String
allUsers =
  fromList
    [ ("en", "All users")
    , ("ru", "Все пользователи")
    ]

admins : Dict String String
admins =
  fromList
    [ ("en", "Admins")
    , ("ru", "Администраторы")
    ]

banlist : Dict String String
banlist =
  fromList
    [ ("en", "Banlist")
    , ("ru", "Банлист")
    ]

myPackages : Dict String String
myPackages =
  fromList
    [ ("en", "My packages")
    , ("ru", "Мои пакеты")
    ]

packages : Dict String String
packages =
  fromList
    [ ("en", "Packages")
    , ("ru", "Пакеты")
    ]


-- Register
------------------------------------------------------------------------------------------------------------------------
registration : Dict String String
registration =
  fromList
    [ ("en", "Registration")
    , ("ru", "Регистрация")
    ]

email : Dict String String
email =
  fromList
    [ ("en", "E-mail")
    , ("ru", "E-mail")
    ]


-- Update
------------------------------------------------------------------------------------------------------------------------
incorrentLoginData : Dict String String
incorrentLoginData =
  fromList
    [ ("en", "Looks like either your nickname or password were incorrect. Wanna try again?")
    , ("ru", "Никнейм или пароль неверны. Попробуете снова?")
    ]

cannotLogout : Dict String String
cannotLogout =
  fromList
    [ ("en", "For some reason, you can't close your session. Maybe you stay a little longer?")
    , ("ru", "По какой-то причине, закрыть сессию не удалось. Может останетесь подольше?")
    ]

failedToFetchUserData : Dict String String
failedToFetchUserData =
  fromList
    [ ("en", "Failed to fetch user data!")
    , ("ru", "Невозможно получить данные профиля!")
    ]

failedToFetchUserList : Dict String String
failedToFetchUserList =
  fromList
    [ ("en", "Failed to fetch user list!")
    , ("ru", "Невозможно получить список пользователей!")
    ]

registrationSuccessfull : Dict String String
registrationSuccessfull =
  fromList
    [ ("en", "You have registered successfully!")
    , ("ru", "Вы успешно зарегистрировались!")
    ]

registrationFailed : Dict String String
registrationFailed =
  fromList
    [ ("en", "Failed to register! Check the entered data, please.")
    , ("ru", "Не удалось зарегистрироваться! Проверьте введённые данные, пожалуйста.")
    ]

userDataSaved : Dict String String
userDataSaved =
  fromList
    [ ("en", "User data was successfully saved!")
    , ("ru", "Профиль успешно сохранён!")
    ]

failedToSaveUserData : Dict String String
failedToSaveUserData =
  fromList
    [ ("en", "Oops! Something went wrong, and user data wasn't saved!")
    , ("ru", "Упс! Что-то пошло не так. Сохранить профиль не удалось!")
    ]

userRemoved : Dict String String
userRemoved =
  fromList
    [ ("en", "User account was successfully removed!")
    , ("ru", "Профиль пользователя успешно удалён!")
    ]

failedToRemoveUser : Dict String String
failedToRemoveUser =
  fromList
    [ ("en", "Oops! Something went wrong, and user account wasn't removed!")
    , ("ru", "Упс! Что-то пошло не так. Профиль пользователя удалить не удалось!")
    ]

failedToFetchPackages : Dict String String
failedToFetchPackages =
  fromList
    [ ("en", "Failed to fetch the list of user packages!")
    , ("ru", "Не удалось получить список пакетов пользователя!")
    ]

helLogin : Dict String String
helLogin =
  fromList
    [ ("en", "HEL: Login")
    , ("ru", "HEL: Логин")
    ]

helRegister : Dict String String
helRegister =
  fromList
    [ ("en", "HEL: Registration")
    , ("ru", "HEL: Регистрация")
    ]

helMyProfile : Dict String String
helMyProfile =
  fromList
    [ ("en", "HEL: My profile")
    , ("ru", "HEL: Мой профиль")
    ]

helProfile : Dict String String
helProfile =
  fromList
    [ ("en", " profile")
    , ("ru", " профиль")
    ]

helUserList : Dict String String
helUserList =
  fromList
    [ ("en", "HEL: User list")
    , ("ru", "HEL: Пользователи")
    ]

helEdit : Dict String String
helEdit =
  fromList
    [ ("en", "Edit: ")
    , ("ru", "Редактор: ")
    ]

helMy : Dict String String
helMy =
  fromList
    [ ("en", "my")
    , ("ru", "мой")
    ]

helAbout : Dict String String
helAbout =
  fromList
    [ ("en", "HEL: About")
    , ("ru", "HEL: О репозитории")
    ]
