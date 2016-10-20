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

type alias PkgVersion =
  { version : String
  , files : List PkgVersionFile
  , depends : List PkgVersionDependency
  , changes : String
  }

type alias Package =
  { name : String
  , description : String
  , short_description : String
  , owners : List String
  , authors : List String
  , license : String
  , tags : List String
  , versions : List PkgVersion
  , screenshots : List Screenshot
  }

type alias PackageListData =
  { packages : List Package
  , loading : Bool
  , error : String
  }
