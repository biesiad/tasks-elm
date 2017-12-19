module View exposing (view)

import Actions exposing (..)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, disabled, placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)


view : State -> Html Action
view state =
    div []
        [ button [ onClick AddTask ] [ text "add task" ]
        , button [ disabled (saveButtonDisabled state), onClick SaveTasks ] [ text "Save" ]
        , div [] (List.map (\task -> taskView task) state.tasks)
        , alertView state.alert
        ]


saveButtonDisabled : State -> Bool
saveButtonDisabled state =
    state.tasks == state.serverTasks


taskView : Task -> Html Action
taskView task =
    div []
        [ input [ placeholder "Add title...", value task.title, onInput (UpdateTask task.id) ] []
        , button [ onClick (DeleteTask task) ] [ text "delete" ]
        ]


alertView : Maybe Alert -> Html Action
alertView alert =
    let
        render cssClass message =
            div []
                [ text message
                , button [ onClick CloseAlert ] [ text "x" ]
                ]
    in
    case alert of
        Nothing ->
            div [] []

        Just (Success message) ->
            render "success" message

        Just (Error message) ->
            render "error" message
