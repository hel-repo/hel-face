module Package.Localization exposing (..)

import Dict exposing (Dict, fromList)


get : String -> Dict String String -> String
get lang resource =
  case (Dict.get lang resource) of
    Just string -> string
    Nothing -> ""


-- Update
------------------------------------------------------------------------------------------------------------------------
failedToFetchPackages : Dict String String
failedToFetchPackages =
  fromList
    [ ("en", "Failed to fetch packages!")
    , ("ru", "Ошибка при загрузке списка пакетов!")
    ]

failedToFetchPackage : Dict String String
failedToFetchPackage =
  fromList
    [ ("en", "Failed to fetch package!")
    , ("ru", "Ошибка при загрузке пакета!")
    ]

packageSuccessfullySaved : Dict String String
packageSuccessfullySaved =
  fromList
    [ ("en", "Package was succesfully saved!")
    , ("ru", "Пакет успешно сохранён!")
    ]

failedToSavePackage : Dict String String
failedToSavePackage =
  fromList
    [ ("en", "Failed to save the package!")
    , ("ru", "Ошибка при сохранении пакета!")
    ]

packageSuccessfullyRemoved : Dict String String
packageSuccessfullyRemoved =
  fromList
    [ ("en", "Package was succesfully removed!")
    , ("ru", "Пакет успешно удалён!")
    ]

failedToRemovePackage : Dict String String
failedToRemovePackage =
  fromList
    [ ("en", "Failed to remove the package!")
    , ("ru", "Ошибка при удалении пакета!")
    ]


-- Details
------------------------------------------------------------------------------------------------------------------------
installation : Dict String String
installation =
  fromList
    [ ("en", "Installation")
    , ("ru", "Установка")
    ]

changelog : Dict String String
changelog =
  fromList
    [ ("en", "Changelog")
    , ("ru", "Список изменений")
    ]

files : Dict String String
files =
  fromList
    [ ("en", "Files")
    , ("ru", "Файлы")
    ]

noFiles : Dict String String
noFiles =
  fromList
    [ ("en", "No files")
    , ("ru", "Нет файлов")
    ]

dependsOn : Dict String String
dependsOn =
  fromList
    [ ("en", "Depends on")
    , ("ru", "Зависит от")
    ]

noDependencies : Dict String String
noDependencies =
  fromList
    [ ("en", "No dependencies")
    , ("ru", "Нет зависимостей")
    ]

authorsOfPackage : Dict String String
authorsOfPackage =
  fromList
    [ ("en", "Authors of package")
    , ("ru", "Разработчики пакета")
    ]

sourceCodeLicense : Dict String String
sourceCodeLicense =
  fromList
    [ ("en", "Source code license")
    , ("ru", "Лиценцирование исходного кода")
    ]

packageMaintainers : Dict String String
packageMaintainers =
  fromList
    [ ("en", "Package maintainers")
    , ("ru", "Мейнтейнеры пакета")
    ]

thanks : Dict String String
thanks =
  fromList
    [ ("en", "Thanks! :3")
    , ("ru", "Спасибо! :3")
    ]

like : Dict String String
like =
  fromList
    [ ("en", "Like")
    , ("ru", "Лайк")
    ]

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

packageWithoutVersions : Dict String String
packageWithoutVersions =
  fromList
    [ ("en", "This package does not have any versions. So, you can not download it.")
    , ("ru", "Этот пакет не имеет ни одной версии. Поэтому он не доступен для скачивания.")
    ]

nothingFound : Dict String String
nothingFound =
  fromList
    [ ("en", "Nothing found!")
    , ("ru", "Ничего не найдено!")
    ]

noPackagesWithThisName : Dict String String
noPackagesWithThisName =
  fromList
    [ ("en", "No packages with this name was found in repository.")
    , ("ru", "Ни одного пакета с таким названием в репозитории не найдено.")
    ]
checkSpelling : Dict String String
checkSpelling =
  fromList
    [ ("en", "Check the spelling, or try different name, please.")
    , ("ru", "Проверьте, правильно ли набрано имя пакета, либо попробуйте другое.")
    ]


-- Edit
------------------------------------------------------------------------------------------------------------------------
path : Dict String String
path =
  fromList
    [ ("en", "Path")
    , ("ru", "Путь")
    ]

whichFolder : Dict String String
whichFolder =
  fromList
    [ ("en", "Which folder will this file be installed in?")
    , ("ru", "В какую папку должен быть установлен этот файл?")
    ]

fileName : Dict String String
fileName =
  fromList
    [ ("en", "File name")
    , ("ru", "Имя файла")
    ]

whatName : Dict String String
whatName =
  fromList
    [ ("en", "How this file will be named?")
    , ("ru", "Как должен называться этот файл?")
    ]

url : Dict String String
url =
  fromList
    [ ("en", "URL")
    , ("ru", "URL")
    ]

whichUrl : Dict String String
whichUrl =
  fromList
    [ ("en", "Specify a direct URL for downloading this file")
    , ("ru", "Укажите путь, откуда этот файл будет скачан.")
    ]

newFile : Dict String String
newFile =
  fromList
    [ ("en", "New file")
    , ("ru", "Новый файл")
    ]

packageName : Dict String String
packageName =
  fromList
    [ ("en", "Package name")
    , ("ru", "Имя пакета")
    ]

dependencyNameCantBeEmpty : Dict String String
dependencyNameCantBeEmpty =
  fromList
    [ ("en", "Can't be empty! Specify dependency name.")
    , ("ru", "Не может быть пустым. Укажите имя пакета-зависимости.")
    ]

version : Dict String String
version =
  fromList
    [ ("en", "Version")
    , ("ru", "Версия")
    ]

versionCantBeEmpty : Dict String String
versionCantBeEmpty =
  fromList
    [ ("en", "Can't be empty! You can use asterisk (*) for generic version.")
    , ("ru", "Не может быть пустой. Используйте звёздочку (*), если конкретная версия не важна.")
    ]

newDependency : Dict String String
newDependency =
  fromList
    [ ("en", "New dependency")
    , ("ru", "Новая зависимость")
    ]

directLinkToImage : Dict String String
directLinkToImage =
  fromList
    [ ("en", "Direct link to an image")
    , ("ru", "Прямая ссылка на изображение")
    ]

description : Dict String String
description =
  fromList
    [ ("en", "Description")
    , ("ru", "Описание")
    ]

screenshots : Dict String String
screenshots =
  fromList
    [ ("en", "Screenshots (optional)")
    , ("ru", "Скриншоты (не обязательно)")
    ]

addScreenshot : Dict String String
addScreenshot =
  fromList
    [ ("en", "Add screenshot")
    , ("ru", "Добавить скриншот")
    ]

mustGivePackageName : Dict String String
mustGivePackageName =
  fromList
    [ ("en", "You must give your package some name!")
    , ("ru", "Укажите название вашего пакета!")
    ]

license : Dict String String
license =
  fromList
    [ ("en", "License")
    , ("ru", "Лицензия")
    ]

youCanUseMarkdown : Dict String String
youCanUseMarkdown =
  fromList
    [ ("en", "You can use Markdown markup language in description fields")
    , ("ru", "Вы можете форматировать текст описания при помощи разметки Markdown")
    ]

shortDescription : Dict String String
shortDescription =
  fromList
    [ ("en", "Short description")
    , ("ru", "Короткое описание")
    ]

fullDescription : Dict String String
fullDescription =
  fromList
    [ ("en", "Full description")
    , ("ru", "Полное описание")
    ]

toAddTag : Dict String String
toAddTag =
  fromList
    [ ("en", "To add new tag, enter a value in textbox, and then press Enter")
    , ("ru", "Чтобы добавить тег, введите текст тега и нажмите Enter")
    ]

packageOwner : Dict String String
packageOwner =
  fromList
    [ ("en", "Package owner")
    , ("ru", "Владелец пакета")
    ]

atLeastOneOwner : Dict String String
atLeastOneOwner =
  fromList
    [ ("en", "A package must have at least one owner. Consider adding yourself.")
    , ("ru", "Пакет должен иметь хотя бы одного мейнтейнера. Вы можете добавить свой ник.")
    ]

authorOfProgram : Dict String String
authorOfProgram =
  fromList
    [ ("en", "Author of program")
    , ("ru", "Автор программы")
    ]

contentTag : Dict String String
contentTag =
  fromList
    [ ("en", "Content tag")
    , ("ru", "Контент-тег")
    ]

atLeastOneVersion : Dict String String
atLeastOneVersion =
  fromList
    [ ("en", "The package must contain at least one version to be downloadable.")
    , ("ru", "Чтобы пользователи могли скачивать пакет, он должен иметь хотя бы одну версию.")
    ]

addVersion : Dict String String
addVersion =
  fromList
    [ ("en", "Add version")
    , ("ru", "Добавить версию")
    ]

removeVersion : Dict String String
removeVersion =
  fromList
    [ ("en", "Remove version")
    , ("ru", "Удалить версию")
    ]

versionNumber : Dict String String
versionNumber =
  fromList
    [ ("en", "Version number")
    , ("ru", "Номер версии")
    ]

versionNumberCantBeEmpty : Dict String String
versionNumberCantBeEmpty =
  fromList
    [ ("en", "Can't be empty. Specify version number using semantic versioning rules (x.y.z).")
    , ("ru", "Не может быть пустым. Используйте правила семантического версионирования (x.y.z).")
    ]

versionChanges : Dict String String
versionChanges =
  fromList
    [ ("en", "Version changes")
    , ("ru", "Изменения в этой версии")
    ]

selectVersion : Dict String String
selectVersion =
  fromList
    [ ("en", "Select one of the versions, or add new version to edit.")
    , ("ru", "Для редактирования, выберите одну из версий, либо создайте новую.")
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
directLink : Dict String String
directLink =
  fromList
    [ ("en", "Direct link:")
    , ("ru", "Ссылка на пакет:")
    ]

installViaHpm : Dict String String
installViaHpm =
  fromList
    [ ("en", "Install via HPM:")
    , ("ru", "Установка через HPM:")
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
