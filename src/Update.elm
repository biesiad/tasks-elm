module Update exposing (..)

import Actions exposing (..)
import Api exposing (..)
import Dom
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
            let
                new =
                    newTask state.tasks
            in
            ( { state | tasks = new :: state.tasks }
            , Task.attempt FocusResult (Dom.focus (toString new.id))
            )

        UpdateTask id title ->
            ( { state | tasks = updateTask id title state.tasks }, Cmd.none )

        DeleteTask task ->
            ( { state | tasks = List.filter ((/=) task.id << .id) state.tasks }, Cmd.none )

        SaveTasks ->
            ( { state | isSaving = True }, tasksPostRequest state.tasks )

        ShowAlert alert ->
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
                    update
                        (ShowAlert (newAlert state.alerts (Error (requestError error "Error loading tasks"))))
                        { state | isLoading = False }

        TasksPostRequest result ->
            case result of
                Ok tasks ->
                    update
                        (ShowAlert (newAlert state.alerts (Success "Tasks saved Successfuly!")))
                        { state
                            | serverTasks = state.tasks
                            , isSaving = False
                        }

                Err error ->
                    update
                        (ShowAlert (newAlert state.alerts (Error (requestError error "Error saving tasks"))))
                        { state | isSaving = False }

        FocusResult result ->
            ( state, Cmd.none )


newTask : List Task -> Task
newTask tasks =
    { id = newId tasks, title = "" }


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


newAlert : List Alert -> AlertContent -> Alert
newAlert alerts content =
    { id = newId alerts
    , content = content
    }


requestError : Http.Error -> String -> String
requestError error text =
    case error of
        BadPayload err response ->
            text ++ "(" ++ err ++ ")"

        _ ->
            text


newId : List { x | id : Int } -> Int
newId l =
    Maybe.withDefault 0 (List.maximum (List.map .id l)) + 1


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
