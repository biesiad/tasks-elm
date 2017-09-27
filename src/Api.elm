module Api exposing (tasksGetRequest, tasksPostRequest)

import Json.Decode as Decode
import Json.Encode as Encode
import Http exposing (..)

import Actions exposing (..)
import Types exposing (..)


url : String
url = "https://cfassignment.herokuapp.com/greg/tasks"

tasksGetRequest : Cmd Action
tasksGetRequest =
  Http.send TasksGetRequest (Http.get url tasksDecoder)

tasksPostRequest : List Task -> Cmd Action
tasksPostRequest tasks =
  Http.send TasksPostRequest (Http.post url (Http.jsonBody (tasksEncoder tasks)) tasksDecoder)

tasksDecoder : Decode.Decoder (Maybe (List Task))
tasksDecoder =
  Decode.field "tasks" (Decode.nullable (Decode.list taskDecoder))

tasksEncoder : List Task -> Encode.Value
tasksEncoder tasks =
  Encode.object
    [ ("tasks", Encode.list (List.map taskEncoder tasks)) ]

taskDecoder : Decode.Decoder Task
taskDecoder =
  Decode.map2 Task
    (Decode.field "id" Decode.int)
    (Decode.field "title" Decode.string)

taskEncoder : Task -> Encode.Value
taskEncoder task =
  Encode.object
    [ ("id", Encode.int task.id)
    , ("title", Encode.string task.title)
    ]
