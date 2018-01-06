module Types exposing (..)


type Msg
    = NoOp
    | Move Int Int
    | LoadLevel Int
    | Undo
    | ShowLevelSelector
    | HideOverlay
    | ChangeLevelFromUserInput String
    | LoadLevelFromUserInput


type alias Model =
    IViewLevel
        { isWin : Bool
        , levels : List Level
        , currentLevel : Int
        , movesCount : Int
        , history : List GameState
        , showLevelSelector : Bool
        , stringLevelFromUserInput : String
        }


type alias IViewLevel a =
    { a
        | player : Block
        , walls : List Block
        , boxes : List Block
        , dots : List Block
        , gameSize : ( Int, Int )
    }


type alias GameState =
    { player : Block
    , boxes : List Block
    }


type alias Block =
    { x : Int
    , y : Int
    }


type alias Level =
    { width : Int
    , height : Int
    , map : List (List Char)
    }


type alias ViewLevel =
    IViewLevel {}
