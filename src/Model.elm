module Model exposing (initModel, updateModelFromLocation, updateModelWithLevelFromUserInput)

import Navigation exposing (Location)
import Types exposing (Model, Block, Level, Levels, ViewLevel, Page(..))
import Levels exposing (getInitialLevels, getLevel, addLevel)
import ViewLevel exposing (getViewLevelFromLevel)
import StringLevel exposing (getLevelFromPathName, getLevelFromString)


updateModelWithLevelFromUserInput : Model -> Model
updateModelWithLevelFromUserInput model =
    let
        level =
            model.stringLevelFromUserInput
                |> getLevelFromString
    in
        case level of
            Just level ->
                { model
                    | levels = addLevel level model.levels
                    , stringLevelFromUserInput = ""
                }

            Nothing ->
                { model
                    | stringLevelFromUserInput = ""
                }


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


initModel : Maybe Levels -> Model
initModel maybeLevels =
    let
        levels =
            case maybeLevels of
                Just maybeLevels ->
                    maybeLevels

                Nothing ->
                    getInitialLevels

        viewLevel =
            getViewLevelFromLevel (Level 0 0 [] "")
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = levels -- important here
        , currentLevelId = ""
        , movesCount = 0
        , history = []
        , currentPage = GamePage
        , stringLevelFromUserInput = ""
        }
