module Main exposing (..)

import Actions exposing (Action)
import Html
import Types
import Update
import View


main : Program Never Types.State Action
main =
    Html.program
        { init = Update.init
        , update = Update.update
        , subscriptions = always Sub.none
        , view = View.view
        }
