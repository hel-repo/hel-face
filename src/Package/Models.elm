module Package.Models exposing (..)


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
  , downloads : Int
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

type alias PackageListData =
  { packages : List Package
  , loading : Bool
  , error : String
  }
