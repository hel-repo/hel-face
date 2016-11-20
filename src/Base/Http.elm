module Base.Http exposing (..)

import Http exposing (Error, RawError, Response, defaultSettings)
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)


xpatch : String -> String -> Task RawError Response
xpatch url data =
  Http.send { defaultSettings | withCredentials = True }
    { verb = "PATCH"
    , headers = [ ("Content-Type", "application/json; charset=UTF-8") ]
    , url = url
    , body = Http.string data
    }

xpost : String -> String -> Task RawError Response
xpost url data =
  Http.send { defaultSettings | withCredentials = True }
    { verb = "POST"
    , headers = [ ("Content-Type", "application/json; charset=UTF-8") ]
    , url = url
    , body = Http.string data
    }

xget : Json.Decoder value -> String -> Task Error value
xget decoder url =
  let request =
    { verb = "GET"
    , headers = []
    , url = url
    , body = Http.empty
    }
  in Http.fromJson decoder
    <| Http.send { defaultSettings | withCredentials = True } request

xdelete : String -> Task RawError Response
xdelete url =
  Http.send { defaultSettings | withCredentials = True }
    { verb = "DELETE"
    , headers = []
    , url = url
    , body = Http.empty
    }
