module Model exposing (initModelWithLevelNumber)

import Types exposing (Model, Block, Level, ViewLevel)
import Levels exposing (getLevel)
import ViewLevel exposing (getViewLevelFromLevel)


initModelWithLevelNumber : Int -> Model
initModelWithLevelNumber levelNumber =
    let
        level =
            getLevel levelNumber

        viewLevel =
            getViewLevelFromLevel level
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , currentLevel = levelNumber
        , movesCount = 0
        , history = []
        , showLevelSelector = False
        }
