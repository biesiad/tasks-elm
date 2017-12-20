module View exposing (view)

import Actions exposing (..)
import Html exposing (Html, button, div, i, input, text)
import Html.Attributes exposing (class, disabled, id, placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)


view : State -> Html Action
view state =
    div []
        [ div [ class "header" ] []
        , div [ class "container" ]
            [ div []
                [ button [ class "button", onClick AddTask ] [ text "add task" ]
                , button [ class "button", disabled (saveButtonDisabled state), onClick SaveTasks ] [ text "Save" ]
                ]
            , if state.isLoading && List.length state.tasks == 0 then
                div [] [ text "Loading" ]
              else
                div [] (List.map taskView state.tasks)
            , div [] (List.map alertView state.alerts)
            ]
        ]


saveButtonDisabled : State -> Bool
saveButtonDisabled state =
    state.tasks == state.serverTasks || state.isSaving


taskView : Task -> Html Action
taskView task =
    div [ class "task" ]
        [ input [ class "task-input", id (toString task.id), placeholder "Add title...", value task.title, onInput (UpdateTask task.id) ] []
        , i [ class "fa fa-trash", onClick (DeleteTask task) ] []
        ]


alertView : Alert -> Html Action
alertView alert =
    let
        render cssClass message =
            div []
                [ text message
                , i [ class "fa fa-times", onClick (CloseAlert alert) ] []
                ]
    in
    case alert.content of
        Success message ->
            render "success" message

        Error message ->
            render "error" message
