module View exposing (view)

import Actions exposing (..)
import Html exposing (Html, button, div, h1, i, input, text)
import Html.Attributes exposing (class, disabled, id, placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)


view : State -> Html Action
view state =
    div []
        [ div [ class "header" ] []
        , div [ class "container" ]
            [ div [ class "subheader" ]
                [ h1 [] [ text "Tasks" ]
                , div [ class "subheader-buttons" ]
                    [ button [ class "button", onClick AddTask ] [ text "Add task" ]
                    , button [ class "button", disabled (saveButtonDisabled state), onClick SaveTasks ] [ text "Save" ]
                    ]
                ]
            , if state.isLoading && List.length state.tasks == 0 then
                i [ class "fa fa-circle-o-notch fa-spin fa-3x fa-fw loader" ] []
              else
                div [] (List.map taskView state.tasks)
            , div [ class "alerts" ] (List.map alertView state.alerts)
            ]
        ]


saveButtonDisabled : State -> Bool
saveButtonDisabled state =
    state.tasks == state.serverTasks || state.isSaving


taskView : Task -> Html Action
taskView task =
    div [ class "task" ]
        [ input [ class "task-input", id (toString task.id), placeholder "Add title...", value task.title, onInput (UpdateTask task.id) ] []
        , i [ class "fa fa-trash-o task-delete", onClick (DeleteTask task) ] []
        ]


alertView : Alert -> Html Action
alertView alert =
    let
        render cssClass message =
            div [ class ("alert " ++ cssClass) ]
                [ text message
                , i [ class "fa fa-times alert-close", onClick (CloseAlert alert) ] []
                ]
    in
    case alert.content of
        Success message ->
            render "alert-success" message

        Error message ->
            render "alert-error" message
