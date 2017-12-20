module Actions exposing (..)

import Dom
import Http
import Result
import Types


type Action
    = AddTask
    | UpdateTask Int String
    | DeleteTask Types.Task
    | SaveTasks
    | ShowAlert Types.Alert
    | CloseAlert Types.Alert
    | TasksGetRequest (Result Http.Error (Maybe (List Types.Task)))
    | TasksPostRequest (Result Http.Error (Maybe (List Types.Task)))
    | FocusResult (Result Dom.Error ())
