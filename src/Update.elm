module Update exposing (..)

import Actions exposing (..)
import Api exposing (..)
import Http exposing (..)
import Types exposing (..)


update : Action -> State -> ( State, Cmd Action )
update action state =
    case action of
        TasksGetRequest result ->
            case result of
                Ok tasks ->
                    ( { state
                        | tasks = Maybe.withDefault [] tasks
                        , serverTasks = Maybe.withDefault [] tasks
                      }
                    , Cmd.none
                    )

                Err error ->
                    state |> update (ShowAlert (requestErrorAlert error "Error loading tasks"))

        TasksPostRequest result ->
            case result of
                Ok tasks ->
                    { state | serverTasks = state.tasks } |> update (ShowAlert (Just (Success "Tasks saved Successfuly!")))

                Err error ->
                    ( { state | alert = requestErrorAlert error "Error saving tasks" }, Cmd.none )

        AddTask ->
            ( { state | tasks = newTask state.tasks :: state.tasks }, Cmd.none )

        UpdateTask id title ->
            ( { state | tasks = updateTask id title state.tasks }, Cmd.none )

        DeleteTask task ->
            ( { state | tasks = List.filter ((/=) task.id << .id) state.tasks }, Cmd.none )

        SaveTasks ->
            ( state, tasksPostRequest state.tasks )

        ShowAlert alert ->
            ( { state | alert = alert }, Cmd.none )

        CloseAlert ->
            ( { state | alert = Nothing }, Cmd.none )


newTask : List Task -> Task
newTask tasks =
    { id = newId tasks, title = "" }


newId : List Task -> Int
newId tasks =
    Maybe.withDefault 0 (List.maximum (List.map .id tasks)) + 1


updateTask : Int -> String -> List Task -> List Task
updateTask id title =
    List.map
        (\t ->
            if t.id == id then
                { t | title = title }
            else
                t
        )


tasksDirty : State -> Bool
tasksDirty state =
    state.tasks == state.serverTasks


requestErrorAlert : Http.Error -> String -> Maybe Alert
requestErrorAlert error text =
    case error of
        BadPayload err response ->
            Just (Types.Error (text ++ "(" ++ err ++ ")"))

        _ ->
            Just (Types.Error text)


init : ( State, Cmd Action )
init =
    ( { tasks = []
      , serverTasks = []
      , alert = Nothing
      }
    , tasksGetRequest
    )
