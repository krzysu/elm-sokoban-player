module Model exposing (initModel, updateModelWithLevelNumber, updateModelWithNewLevel)

import Types exposing (Model, Block, Level, ViewLevel)
import Levels exposing (getInitialLevels, getLevel, addLevel)
import ViewLevel exposing (getViewLevelFromLevel)


updateModelWithLevelNumber : Int -> Model -> Model
updateModelWithLevelNumber levelNumber model =
    let
        level : Level
        level =
            getLevel levelNumber model.levels

        viewLevel =
            getViewLevelFromLevel level
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = model.levels
        , currentLevel = levelNumber
        , movesCount = 0
        , history = []
        , showLevelSelector = False
        , stringLevelFromUserInput = ""
        }


updateModelWithNewLevel : Model -> Level -> Model
updateModelWithNewLevel model level =
    let
        viewLevel =
            getViewLevelFromLevel level
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = addLevel model.levels level
        , currentLevel = 0
        , movesCount = 0
        , history = []
        , showLevelSelector = False
        , stringLevelFromUserInput = ""
        }


initModel : Model
initModel =
    let
        currentLevel =
            0

        levels =
            getInitialLevels

        firstLevel =
            getLevel currentLevel levels

        viewLevel =
            getViewLevelFromLevel firstLevel
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = levels
        , currentLevel = currentLevel
        , movesCount = 0
        , history = []
        , showLevelSelector = False
        , stringLevelFromUserInput = ""
        }
