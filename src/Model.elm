module Model exposing (initModel, updateModelFromLocation)

import Navigation exposing (Location)
import Types exposing (Model, Block, Level, ViewLevel, Page(..))
import Levels exposing (getInitialLevels, getLevel, addLevel)
import ViewLevel exposing (getViewLevelFromLevel)
import StringLevel exposing (getLevelFromPathName)


updateModelFromLocation : Location -> Model -> Model
updateModelFromLocation location model =
    let
        maybeLevel =
            location
                |> .pathname
                |> getLevelFromPathName
    in
        case maybeLevel of
            Just maybeLevel ->
                maybeLevel
                    |> updateModelWithNewLevel model

            Nothing ->
                -- show level select page
                { model | currentPage = LevelSelectPage }


updateModelWithNewLevel : Model -> Level -> Model
updateModelWithNewLevel model level =
    let
        viewLevel =
            getViewLevelFromLevel level

        -- TODO make them unique, use Set to keep levels
        newLevels =
            addLevel model.levels level
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = newLevels
        , currentLevel = 0
        , movesCount = 0
        , history = []
        , currentPage = GamePage
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
        , currentPage = GamePage
        , stringLevelFromUserInput = ""
        }
