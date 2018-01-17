module Types exposing (..)

import Dict exposing (Dict)
import Array exposing (Array)
import Navigation exposing (Location)


type Msg
    = NoOp
    | Move Int Int
    | Undo
    | ShowLevelSelectPage
    | LoadNextLevel
    | LoadLevel Int -- load by level index
    | RemoveLevel String
    | ChangeLevelFromUserInput String
    | AddLevelFromUserInput
    | UrlChange Location


type alias Model =
    IViewLevel
        { isWin : Bool
        , levels : LevelCollection
        , currentLevelIndex : Int
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


{-| intermediary format, should not be used directly
-}
type alias Level =
    { width : Int
    , height : Int
    , map : List (List Char)
    , id : String
    }


{-| in use also as level id
-}
type alias EncodedLevel =
    String


type alias LevelCollection =
    Array EncodedLevel


type alias ViewLevel =
    IViewLevel {}


type alias LevelMeta =
    { bestMovesCount : Int }


type alias LevelMetaCollection =
    Dict EncodedLevel LevelMeta


type Page
    = GamePage
    | LevelSelectPage
