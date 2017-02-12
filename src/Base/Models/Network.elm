module Base.Models.Network exposing (..)


type alias Page a b =
  { list : List a
  , query : b
  , offset : Int
  , total: Int
  }

firstPage : b -> Page a b
firstPage query = { list = [], query = query, offset = 0, total = 0 }

customPage : Int -> b -> Page a b
customPage offset query = { list = [], query = query, offset = offset, total = 0 }


type alias ApiResult =
  { code : Int
  , data : String
  , loggedIn : Bool
  , success : Bool
  , title : String
  , version : String
  }

emptyApiResult : ApiResult
emptyApiResult =
  { code = 204
  , data = "Success!"
  , loggedIn = True
  , success = True
  , title = "No Content"
  , version = "0.0.0"
  }
