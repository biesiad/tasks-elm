import Html

import View
import Update
import Types
import Actions exposing (Action)


main : Program Never Types.State Action
main =
  Html.program
    { init = Update.init
    , update = Update.update
    , subscriptions = always Sub.none
    , view = View.view
    }
