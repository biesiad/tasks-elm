module View exposing (view)

import Actions exposing (..)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, disabled, placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)
import Update exposing (..)


view : State -> Html Action
view state =
    div []
        [ button [ onClick AddTask ] [ text "add task" ]
        , button [ disabled (tasksDirty state), onClick SaveTasks ] [ text "Save" ]
        , div [] (List.map (\task -> taskView task) state.tasks)
        , alertView state.alert
        ]


taskView : Task -> Html Action
taskView task =
    div []
        [ input [ placeholder "Add title...", value task.title, onInput (UpdateTask task.id) ] []
        , button [ onClick (DeleteTask task) ] [ text "delete" ]
        ]


alertView : Maybe Alert -> Html Action
alertView alert =
    case alert of
        Nothing ->
            div [] []

        Just (Success message) ->
            div []
                [ text message
                , button [ onClick CloseAlert ] [ text "x" ]
                ]

        Just (Error message) ->
            div []
                [ text message
                , button [ onClick CloseAlert ] [ text "x" ]
                ]
