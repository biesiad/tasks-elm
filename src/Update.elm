module Update exposing (..)

import Http exposing (..)

import Types exposing (..)
import Actions exposing (..)
import Api exposing (..)


update : Action -> State -> (State, Cmd Action)
update action state =
  case action of
    TasksGetRequest result ->
      case result of
        Ok tasks ->
          ({ state
            | tasks = Maybe.withDefault [] tasks
            , serverTasks = Maybe.withDefault [] tasks
          }, Cmd.none)
        Err error ->
          ({ state | alert = (requestErrorAlert error  "Error loading tasks") }, Cmd.none)
    TasksPostRequest result ->
      case result of
        Ok tasks ->
          ({ state | serverTasks = state.tasks }, Cmd.none)
        Err error ->
          ({ state | alert = (requestErrorAlert error "Error saving tasks") }, Cmd.none)
    AddTask ->
      ({ state | tasks = state.tasks ++ [newTask state.tasks] }, Cmd.none)
    SaveTasks ->
      (state, tasksPostRequest state.tasks)
    DeleteTask task ->
      ({ state | tasks = List.filter (((/=) task.id) << .id) state.tasks }, Cmd.none)
    CloseAlert ->
      ({ state | alert = { visible = False, text = "" }}, Cmd.none)


newTask : List Task -> Task
newTask tasks =
  { id = newId tasks, title = "New Task" ++ toString (newId tasks) }

newId : List Task -> Int
newId tasks =
  (Maybe.withDefault 0 (List.maximum (List.map .id tasks))) + 1

tasksDirty: State -> Bool
tasksDirty state =
  List.map .id state.tasks == List.map .id state.serverTasks

alert: String -> Alert
alert text =
  { text = text
  , visible = True
  }

requestErrorAlert : Http.Error -> String -> Alert
requestErrorAlert error text =
  case error of
    BadPayload err response  ->
      alert (text ++ "(" ++ err ++ ")")
    _ ->
      alert text

init : (State, Cmd Action)
init =
  ( { tasks = []
    , serverTasks = []
    , alert =
      { text = ""
      , visible = False
      }
    }
    , tasksGetRequest
  )
