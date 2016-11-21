module Base.Config exposing (..)

import Time exposing (Time, second)


apiHost : String
apiHost = "https://hel-roottree.rhcloud.com/"

version : String
version = "0.2.0"

enterKey : Int
enterKey = 13

tickDelay : Time
tickDelay = 5 * second

notificationDelay : Time
notificationDelay = 10 * second
