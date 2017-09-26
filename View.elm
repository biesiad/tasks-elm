module View exposing (view)

import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (placeholder, value, disabled)
import Html.Events exposing (onClick)

import Actions exposing (..)
import Update exposing (..)
import Types exposing (..)


view : State -> Html Action
view state =
  div []
    [ button [ disabled (tasksDirty state), onClick SaveTasks ] [ text "save" ]
    , button [ onClick AddTask ] [ text "add task" ]
    , div [] (List.map (\task -> taskView task) state.tasks)
    , alertView state.alert
    ]

taskView : Task -> Html Action
taskView task =
  div []
    [ input [ placeholder "Task name", value task.title] []
    , button [ onClick (DeleteTask task) ] [ text "delete" ]
    ]

alertView : Alert -> Html Action
alertView alert =
  case alert.visible of
    False ->
      div [] []
    True ->
      div []
        [ text alert.text
        , button [ onClick CloseAlert ] [ text "x" ]
        ]
