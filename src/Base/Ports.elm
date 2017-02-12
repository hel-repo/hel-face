port module Base.Ports exposing(..)

port title : String -> Cmd msg

port save : String -> Cmd msg
port load : (String -> msg) -> Sub msg
port doload : () -> Cmd msg
