module Update exposing (..)

import Actions exposing (..)
import Api exposing (..)
import Date
import Http exposing (..)
import Process
import Result
import Task
import Time
import Types exposing (..)


update : Action -> State -> ( State, Cmd Action )
update action state =
    case action of
        AddTask ->
            ( state, Task.perform (\date -> CreateTask (Date.millisecond date)) Date.now )

        UpdateTask id title ->
            ( { state | tasks = updateTask id title state.tasks }, Cmd.none )

        DeleteTask task ->
            ( { state | tasks = List.filter ((/=) task.id << .id) state.tasks }, Cmd.none )

        SaveTasks ->
            ( { state | isSaving = True }, tasksPostRequest state.tasks )

        AddAlert content date ->
            let
                alert =
                    { id = Date.millisecond date, content = content }
            in
            ( { state | alerts = alert :: state.alerts }
            , Task.perform (\_ -> CloseAlert alert) (Process.sleep (5 * Time.second))
            )

        CloseAlert alert ->
            ( { state | alerts = List.filter ((/=) alert.id << .id) state.alerts }, Cmd.none )

        TasksGetRequest result ->
            case result of
                Ok tasks ->
                    ( { state
                        | tasks = Maybe.withDefault [] tasks
                        , serverTasks = Maybe.withDefault [] tasks
                        , isLoading = False
                      }
                    , Cmd.none
                    )

                Err error ->
                    ( { state | isLoading = False }
                    , Task.perform (AddAlert (Error (requestError error "Error loading tasks"))) Date.now
                    )

        TasksPostRequest result ->
            case result of
                Ok tasks ->
                    ( { state
                        | serverTasks = state.tasks
                        , isSaving = False
                      }
                    , Task.perform (AddAlert (Success "Tasks saved Successfuly!")) Date.now
                    )

                Err error ->
                    ( { state | isSaving = False }, Task.perform (AddAlert (Error (requestError error "Error saving tasks"))) Date.now )

        FocusResult result ->
            ( state, Cmd.none )

        CreateTask id ->
            ( { state | tasks = { id = id, title = "" } :: state.tasks }, Cmd.none )


updateTask : Int -> String -> List Task -> List Task
updateTask id title =
    let
        update task =
            if task.id == id then
                { task | title = title }
            else
                task
    in
    List.map update


requestError : Http.Error -> String -> String
requestError error text =
    case error of
        BadPayload err response ->
            text ++ "(" ++ err ++ ")"

        _ ->
            text


init : ( State, Cmd Action )
init =
    ( { tasks = []
      , serverTasks = []
      , alerts = []
      , isLoading = True
      , isSaving = False
      }
    , tasksGetRequest
    )
