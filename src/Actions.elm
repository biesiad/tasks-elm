module Actions exposing (..)

import Http
import Types


type Action
  = SaveTasks
  | AddTask
  | CloseAlert
  | DeleteTask Types.Task
  | TasksGetRequest (Result Http.Error (Maybe (List Types.Task)))
  | TasksPostRequest (Result Http.Error (Maybe (List Types.Task)))
