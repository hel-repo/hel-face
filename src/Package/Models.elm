module Package.Models exposing (..)

import Material


type alias Screenshot =
  { url : String
  , description : String
  }

type alias PkgVersionFileData =
  { dir : String
  , name : String
  }

type alias PkgVersionFile =
  { url : String
  , dir : String
  , name : String
  }

type alias PkgVersionDependencyData =
  { deptype : String
  , version : String
  }

type alias PkgVersionDependency =
  { name: String
  , deptype : String
  , version : String
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
  }

type alias PkgStatsDate =
  { created : String
  , last_updated : String
  }

type alias Stats =
  { views : Int
  , date : PkgStatsDate
  }

type alias Package =
  { name : String
  , description : String
  , short_description : String
  , owners : List String
  , authors : List String
  , license : String
  , tags : List String
  , versions : List Version
  , screenshots : List Screenshot
  , stats : Stats
  }


type alias PackageData =
  { mdl : Material.Model
  , packages : List Package
  , version : Int
  , loading : Bool
  , share : String
  , username : String
  }

emptyPackageData : Material.Model -> PackageData
emptyPackageData materialModel =
  { mdl = materialModel
  , packages = []
  , loading = False
  , version = 0
  , share = ""
  , username = ""
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
