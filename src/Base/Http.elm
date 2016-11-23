module Base.Http exposing (..)

import Http exposing (Body, Request, expectJson, expectStringResponse, emptyBody, stringBody)
import Json.Decode as Decode exposing (field)

import Base.Models exposing (ApiResult, emptyApiResult)
import Base.Decoders exposing (apiResultDecoder)


xpatch : String -> String -> Request ApiResult
xpatch url data =
  Http.request
    { method = "PATCH"
    , headers = []
    , url = url
    , body = stringBody "application/json; charset=UTF-8" data
    , expect = expectStringResponse (\_ -> Ok emptyApiResult )  -- because of API returning empty body
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
    , expect = expectJson apiResultDecoder
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
    , expect = expectStringResponse (\_ -> Ok emptyApiResult )  -- because of API returning empty body
    , timeout = Nothing
    , withCredentials = True
    }
