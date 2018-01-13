module Types exposing (..)

import Dict exposing (Dict)
import Navigation exposing (Location)


type Msg
    = NoOp
    | Move Int Int
    | Undo
    | ShowLevelSelectPage
    | LoadNextLevel
    | LoadLevel String
    | RemoveLevel String
    | ChangeLevelFromUserInput String
    | AddLevelFromUserInput
    | UrlChange Location


type alias Model =
    IViewLevel
        { isWin : Bool
        , levels : Levels
        , currentLevelId : String
        , movesCount : Int
        , history : List GameState
        , currentPage : Page
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
    , id : String
    }


type alias Levels =
    Dict String Level


type alias ViewLevel =
    IViewLevel {}


type Page
    = GamePage
    | LevelSelectPage
