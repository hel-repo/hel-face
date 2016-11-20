module Base.Http exposing (..)

import Http exposing (Body, Request, expectJson, expectStringResponse, emptyBody, stringBody)
import Json.Decode as Decode exposing (field)
import Json.Decode.Extra exposing ((|:))


-- TODO: move this model to Api module
type alias ApiResult =
  { code : Int
  , data : String
  , loggedIn : Bool
  , success : Bool
  , title : String
  , version : String
  }

resultDecoder : Decode.Decoder ApiResult
resultDecoder =
  Decode.succeed ApiResult
    |: (field "code" Decode.int)
    |: Decode.oneOf [field "data" Decode.string, Decode.succeed ""]
    |: (field "logged_in" Decode.bool)
    |: (field "success" Decode.bool)
    |: (field "title" Decode.string)
    |: (field "version" Decode.string)


xpatch : String -> String -> Request ApiResult
xpatch url data =
  Http.request
    { method = "PATCH"
    , headers = []
    , url = url
    , body = stringBody "application/json; charset=UTF-8" data
    , expect = expectStringResponse (\_ -> Ok <| ApiResult 204 "Success!" True True "No Content" "")  -- TODO: fix
    , timeout = Nothing
    , withCredentials = True
    }

xpost : String -> String -> Request ApiResult
xpost url data =
  Http.request
    { method = "POST"
    , headers = []
    , url = url
    , body = stringBody "application/json; charset=UTF-8" data
    , expect = expectJson resultDecoder
    , timeout = Nothing
    , withCredentials = True
    }

xget : String -> Decode.Decoder a -> Request a
xget url decoder =
  Http.request
    { method = "GET"
    , headers = []
    , url = url
    , body = emptyBody
    , expect = expectJson decoder
    , timeout = Nothing
    , withCredentials = True
    }

xdelete : String -> Request ApiResult
xdelete url =
  Http.request
    { method = "DELETE"
    , headers = []
    , url = url
    , body = emptyBody
    , expect = expectStringResponse (\_ -> Ok <| ApiResult 204 "Success!" True True "No Content" "")  -- TODO: fix
    , timeout = Nothing
    , withCredentials = True
    }
