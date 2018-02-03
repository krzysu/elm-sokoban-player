module Types exposing (..)

import Dict exposing (Dict)
import Array exposing (Array)
import Navigation exposing (Location)
import Window


type alias Flags =
    { levels : Maybe String
    , levelsData : Maybe String
    }


type Msg
    = NoOp
    | Move MoveDirection
    | Undo
    | ShowPage Page
    | ShowOverlay Overlay
    | RestartLevel
    | LoadNextLevel
    | LoadLevel EncodedLevel
    | AddLevel EncodedLevel
    | RemoveLevel EncodedLevel
    | ChangeLevelFromUserInput String
    | AddLevelFromUserInput
    | UrlChange Location
    | WindowSizeUpdated Window.Size
    | RandomLevel Int


type alias Model =
    IViewLevel
        { isWin : Bool
        , lastMoveDirection : MoveDirection
        , levels : LevelCollection
        , currentEncodedLevel : EncodedLevel
        , currentLevelIndex : Int
        , movesCount : Int
        , history : List GameState
        , currentPage : Page
        , currentOverlay : Overlay
        , stringLevelFromUserInput : String
        , levelsData : LevelDataCollection
        , windowSize : Window.Size
        , randomLevelIndex : Int
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
    , lastMoveDirection : MoveDirection
    }


type alias Block =
    { x : Int
    , y : Int
    }


type MoveDirection
    = Left
    | Right
    | Up
    | Down


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


type alias LevelData =
    { bestMovesCount : Int }


type alias LevelDataCollection =
    Dict EncodedLevel LevelData


type Page
    = GamePage
    | PlaylistPage
    | HomePage
    | MoreLevelsPage


type Overlay
    = NoOverlay
    | InfoOverlay
