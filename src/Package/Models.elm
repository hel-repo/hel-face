module Package.Models exposing (..)

import Material


type alias Screenshot =
  { url : String
  , description : String
  }

emptyScreenshot : Screenshot
emptyScreenshot =
  { url = ""
  , description = ""
  }

type alias PkgVersionFileData =
  { dir : String
  , name : String
  }

type alias PkgVersionFile =
  { url : String
  , dir : String
  , name : String
  , remove : Bool
  }

emptyFile : PkgVersionFile
emptyFile =
  { url = ""
  , dir = ""
  , name = ""
  , remove = False
  }

type alias PkgVersionDependencyData =
  { deptype : String
  , version : String
  }

type alias PkgVersionDependency =
  { name: String
  , deptype : String
  , version : String
  , remove : Bool
  }

emptyDependency : PkgVersionDependency
emptyDependency =
  { name = ""
  , deptype = "required"
  , version = "*"
  , remove = False
  }

type alias PkgVersionData =
  { files : List PkgVersionFile
  , depends : List PkgVersionDependency
  , changes : String
  }

type alias Version =
  { version : String
  , files : List PkgVersionFile
  , depends : List PkgVersionDependency
  , changes : String
  , remove : Bool
  }

emptyVersion : Version
emptyVersion =
  { version = "x.y.z"
  , files = []
  , depends = []
  , changes = ""
  , remove = False
  }

type alias PkgStatsDate =
  { created : String
  , lastUpdated : String
  }

type alias Stats =
  { views : Int
  , date : PkgStatsDate
  }

emptyStats: Stats
emptyStats = { views = 0, date = { created = "", lastUpdated = "" } }

type alias Package =
  { name : String
  , description : String
  , shortDescription : String
  , owners : List String
  , authors : List String
  , license : String
  , tags : List String
  , versions : List Version
  , screenshots : List Screenshot
  , stats : Stats
  }

emptyPackage : Package
emptyPackage =
  { name = ""
  , description = ""
  , shortDescription = ""
  , owners = []
  , authors = []
  , license = "MIT"
  , tags = []
  , versions = []
  , screenshots = []
  , stats = emptyStats
  }


type TagType = Owner | Author | Content
type alias Tags =
  { active : TagType
  , owner : String
  , author : String
  , content : String
  }

emptyTags : Tags
emptyTags =
  { active = Owner
  , owner = ""
  , author = ""
  , content = ""
  }


type alias PackageData =
  { mdl : Material.Model
  , packages : List Package
  , package : Package
  , oldPackage : Package   -- backup for changes resolver
  , version : Int          -- currently selected version tab
  , loading : Bool
  , share : String         -- which card was triggered to show sharing links
  , username : String      -- current user nickname
  , tags : Tags            -- tag textboxes state, for edit form
  }

emptyPackageData : Material.Model -> PackageData
emptyPackageData materialModel =
  { mdl = materialModel
  , packages = []
  , package = emptyPackage
  , oldPackage = emptyPackage
  , loading = False
  , version = 0
  , share = ""
  , username = ""
  , tags = emptyTags
  }


type alias SearchData =
  { name : String
  }

searchAll : SearchData
searchAll =
  { name = ""
  }

searchByName : String -> SearchData
searchByName str =
  { searchAll
  | name = str
  }
