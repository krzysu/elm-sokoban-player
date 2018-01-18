module Model exposing (initModel, updateModelFromLocation)

import Dict
import Navigation exposing (Location)
import Types exposing (Model, Msg, Block, EncodedLevel, LevelCollection, LevelDataCollection, Page(..))
import LevelCollection
import Storage
import Level exposing (getViewLevelFromEncodedLevel, getEncodedLevelFromPathName)


updateModelFromLocation : Location -> Model -> ( Model, Cmd Msg )
updateModelFromLocation location model =
    let
        encodedLevel =
            location
                |> .pathname
                |> getEncodedLevelFromPathName
    in
        case encodedLevel of
            Just encodedLevel ->
                checkAndLoadGameWithLevel encodedLevel model

            Nothing ->
                ( { model | currentPage = LevelSelectPage }
                , Cmd.none
                )


{-| load level, new or existing
set currentLevelIndex in each case
-}
checkAndLoadGameWithLevel : EncodedLevel -> Model -> ( Model, Cmd Msg )
checkAndLoadGameWithLevel encodedLevel model =
    let
        isExistingLevel =
            LevelCollection.isDuplicate encodedLevel model.levels
    in
        if isExistingLevel then
            loadGameWithExistingLevel encodedLevel model
        else
            loadGameWithNewLevel encodedLevel model


loadGameWithExistingLevel : EncodedLevel -> Model -> ( Model, Cmd Msg )
loadGameWithExistingLevel level model =
    let
        modelWithGame =
            loadGameWithLevel level model

        levelIndex =
            LevelCollection.getIndexOf level model.levels
    in
        ( { modelWithGame
            | currentLevelIndex = levelIndex
          }
        , Cmd.none
        )


loadGameWithNewLevel : EncodedLevel -> Model -> ( Model, Cmd Msg )
loadGameWithNewLevel level model =
    let
        modelWithGame =
            loadGameWithLevel level model

        newLevels =
            LevelCollection.prependLevel level model.levels
    in
        ( { modelWithGame
            | levels = newLevels
            , currentLevelIndex = 0
          }
        , Storage.storeLevels newLevels
        )


{-| only load new level and reset all related model props
-}
loadGameWithLevel : EncodedLevel -> Model -> Model
loadGameWithLevel encodedLevel model =
    let
        viewLevel =
            getViewLevelFromEncodedLevel encodedLevel

        levelData =
            Dict.get encodedLevel model.levelsData

        bestMovesCount =
            levelData |> Maybe.map .bestMovesCount
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = model.levels -- not updated here
        , currentLevelIndex = model.currentLevelIndex -- not updated here
        , movesCount = 0
        , bestMovesCount = Maybe.withDefault 0 bestMovesCount
        , history = []
        , currentPage = GamePage
        , stringLevelFromUserInput = ""
        , levelsData = model.levelsData
        }


{-| only when init the app
-}
initModel : Maybe LevelCollection -> LevelDataCollection -> Model
initModel maybeLevels levelsData =
    let
        levels =
            case maybeLevels of
                Just maybeLevels ->
                    maybeLevels

                Nothing ->
                    LevelCollection.getInitialLevels
    in
        { player = Block 0 0
        , walls = []
        , boxes = []
        , dots = []
        , gameSize = ( 0, 0 )
        , isWin = False
        , levels = levels -- important here
        , currentLevelIndex = 0
        , movesCount = 0
        , bestMovesCount = 0
        , history = []
        , currentPage = LevelSelectPage
        , stringLevelFromUserInput = ""
        , levelsData = levelsData
        }
