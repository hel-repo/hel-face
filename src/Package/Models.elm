module Package.Models exposing (..)

import Material

import Base.Models exposing (Package, emptyPackage, Session, emptySession)


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
  , session : Session
  , packages : List Package
  , package : Package
  , oldPackage : Package   -- backup for changes resolver
  , version : Int          -- currently selected version tab
  , screenshot : Int       -- currently selected screenshot
  , loading : Bool
  , share : String         -- which card was triggered to show sharing links
  , tags : Tags            -- tag textboxes state, for edit form
  , validate : Bool        -- show validation messages below textfields (usually after edit confirmation)
  }

emptyPackageData : Material.Model -> PackageData
emptyPackageData materialModel =
  { mdl = materialModel
  , session = emptySession
  , packages = []
  , package = emptyPackage
  , oldPackage = emptyPackage
  , loading = False
  , version = 0
  , screenshot = 0
  , share = ""
  , tags = emptyTags
  , validate = False
  }
