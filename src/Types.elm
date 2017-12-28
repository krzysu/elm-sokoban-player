module Types exposing (..)


type alias Model =
    { player : Block
    , walls : List Block
    , boxes : List Block
    , dots : List Block
    , isWin : Bool
    , gameSize : ( Int, Int )
    , currentLevel : Int
    , movesCount : Int
    , history : List GameState
    }


type alias GameState =
    { player : Block
    , boxes : List Block
    }


type Msg
    = NoOp
    | Move Int Int
    | LoadLevel Int
    | Undo


type alias Block =
    { x : Int
    , y : Int
    }


type alias Level =
    { width : Int
    , height : Int
    , map : List (List Char)
    }
