module Types exposing (..)


type alias State =
    { tasks : List Task
    , serverTasks : List Task
    , alert : Maybe Alert
    }


type alias Task =
    { id : Int
    , title : String
    }


type Alert
    = Success String
    | Error String
