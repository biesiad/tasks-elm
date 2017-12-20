module Types exposing (..)


type alias State =
    { tasks : List Task
    , serverTasks : List Task
    , alerts : List Alert
    , isLoading : Bool
    , isSaving : Bool
    }


type alias Task =
    { id : Int
    , title : String
    }


type alias Alert =
    { id : Int
    , content : AlertContent
    }


type AlertContent
    = Success String
    | Error String
