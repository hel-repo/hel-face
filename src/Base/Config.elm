module Base.Config exposing (..)

import Time exposing (Time, second)


apiHost : String
apiHost = "https://hel-roottree.rhcloud.com/"

enterKey : Int
enterKey = 13

tickDelay : Time
tickDelay = 5 * second

notificationDelay : Time
notificationDelay = 10 * second
