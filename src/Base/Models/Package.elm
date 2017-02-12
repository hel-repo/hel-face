module Base.Models.Package exposing (..)

import Base.Config as Config


type alias Screenshot =
  { url : String
  , description : String
  , remove : Bool
  }

emptyScreenshot : Screenshot
emptyScreenshot =
  { url = ""
  , description = ""
  , remove = False
  }


type alias PkgVersionFileData =
  { dir : String
  , name : String
  }

type alias VersionFile =
  { url : String
  , dir : String
  , name : String
  , remove : Bool
  }

emptyFile : VersionFile
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

type alias VersionDependency =
  { name: String
  , deptype : String
  , version : String
  , remove : Bool
  }

emptyDependency : VersionDependency
emptyDependency =
  { name = ""
  , deptype = "required"
  , version = "*"
  , remove = False
  }


type alias PkgVersionData =
  { files : List VersionFile
  , depends : List VersionDependency
  , changes : String
  }

type alias Version =
  { version : String
  , files : List VersionFile
  , depends : List VersionDependency
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
  , license = Config.defaultLicense
  , tags = []
  , versions = []
  , screenshots = []
  , stats = emptyStats
  }
