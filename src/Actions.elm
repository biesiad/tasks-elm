module Actions exposing (..)

import Date
import Dom
import Http
import Result
import Types


type Action
    = AddTask
    | CreateTask Int
    | UpdateTask Int String
    | DeleteTask Types.Task
    | SaveTasks
    | AddAlert Types.AlertContent Date.Date
    | CloseAlert Types.Alert
    | TasksGetRequest (Result Http.Error (Maybe (List Types.Task)))
    | TasksPostRequest (Result Http.Error (Maybe (List Types.Task)))
    | FocusResult (Result Dom.Error ())
