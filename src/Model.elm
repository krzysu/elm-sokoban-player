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

        newLevels =
            addLevel level model.levels
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = newLevels
        , currentLevelId = level.id
        , movesCount = 0
        , history = []
        , currentPage = GamePage
        , stringLevelFromUserInput = ""
        }


initModel : Model
initModel =
    let
        viewLevel =
            getViewLevelFromLevel (Level 0 0 [] "")
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = getInitialLevels -- important here
        , currentLevelId = ""
        , movesCount = 0
        , history = []
        , currentPage = GamePage
        , stringLevelFromUserInput = ""
        }
