module Localization exposing (..)

import Dict exposing (Dict, fromList)


get : String -> Dict.Dict String String -> String
get lang resource =
  case (Dict.get lang resource) of
    Just string -> string
    Nothing -> ""


-- About
------------------------------------------------------------------------------------------------------------------------
aboutUs : Dict String String
aboutUs =
  fromList
    [ ("en", "About us")
    , ("ru", "О репозитории")
    ]

anEasyWay : Dict String String
anEasyWay =
  fromList
    [ ("en", "An easy way to distribute your applications")
    , ("ru", "Простой способ распространения ваших программ")
    ]

irc : Dict String String
irc =
  fromList
    [ ("en", "IRC channel:")
    , ("ru", "IRC канал:")
    ]

version : Dict String String
version =
  fromList
    [ ("en", "Version (Website/API):")
    , ("ru", "Версия (Вебсайт/API):")
    ]


-- Update
------------------------------------------------------------------------------------------------------------------------
failedToGetSession : Dict String String
failedToGetSession =
  fromList
    [ ("en", "Failed to check user session data!")
    , ("ru", "Не удалось проверить текущую сессию!")
    ]

failedToGetProfile : Dict String String
failedToGetProfile =
  fromList
    [ ("en", "Cannot fetch your user data!")
    , ("ru", "Не удалось получить данные вашего профиля!")
    ]


-- View
------------------------------------------------------------------------------------------------------------------------
error404 : Dict String String
error404 =
  fromList
    [ ("en", "404: Page does not exist!")
    , ("ru", "404: Страница не существует!")
    ]

checkSpelling : Dict String String
checkSpelling =
  fromList
    [ ("en", "Check the address for typing errors.")
    , ("ru", "Проверьте правильность написания адреса или перейдите на главную.")
    ]
