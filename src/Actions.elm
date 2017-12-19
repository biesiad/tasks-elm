module Actions exposing (..)

import Http
import Types


type Action
    = AddTask
    | UpdateTask Int String
    | DeleteTask Types.Task
    | SaveTasks
    | ShowAlert (Maybe Types.Alert)
    | CloseAlert
    | TasksGetRequest (Result Http.Error (Maybe (List Types.Task)))
    | TasksPostRequest (Result Http.Error (Maybe (List Types.Task)))
