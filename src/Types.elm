module Types exposing (..)

import Http exposing (..)


type alias State =
  { tasks: List Task
  , serverTasks: List Task
  , alert: Alert
  }

type alias Task =
  { id : Int
  , title : String
  }

type alias Alert =
  { text: String
  , visible: Bool
  }
