module Base.Http exposing (..)

import Http exposing (Error, RawError, Response, defaultSettings)
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)


patch' : String -> String -> Task RawError Response
patch' url data =
  Http.send { defaultSettings | withCredentials = True }
    { verb = "PATCH"
    , headers = [ ("Content-Type", "application/json; charset=UTF-8") ]
    , url = url
    , body = Http.string data
    }

post' : String -> String -> Task RawError Response
post' url data =
  Http.send { defaultSettings | withCredentials = True }
    { verb = "POST"
    , headers = [ ("Content-Type", "application/json; charset=UTF-8") ]
    , url = url
    , body = Http.string data
    }

get' : Json.Decoder value -> String -> Task Error value
get' decoder url =
  let request =
        { verb = "GET"
        , headers = []
        , url = url
        , body = Http.empty
        }
  in Http.fromJson decoder
        <| Http.send { defaultSettings | withCredentials = True } request