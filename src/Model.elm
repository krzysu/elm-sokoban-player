module Model exposing (initModel, updateModelFromLocation)

import Navigation exposing (Location)
import Window
import Task
import Types
    exposing
        ( Model
        , Msg(..)
        , Flags
        , Block
        , EncodedLevel
        , LevelCollection
        , LevelDataCollection
        , Page(..)
        , MoveDirection(..)
        )
import LevelCollection
import Storage
import Level exposing (getViewLevelFromEncodedLevel, getEncodedLevelFromPathName)
import TouchEvents


updateModelFromLocation : Location -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateModelFromLocation location ( model, cmd ) =
    let
        encodedLevel =
            location
                |> .pathname
                |> getEncodedLevelFromPathName
    in
        case encodedLevel of
            Just encodedLevel ->
                checkAndLoadGameWithLevel encodedLevel ( model, cmd )

            Nothing ->
                ( { model | currentPage = HomePage }
                , cmd
                )


{-| load level, new or existing
set currentLevelIndex in each case
-}
checkAndLoadGameWithLevel : EncodedLevel -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkAndLoadGameWithLevel encodedLevel ( model, cmd ) =
    let
        isExistingLevel =
            LevelCollection.isDuplicate encodedLevel model.levels
    in
        if isExistingLevel then
            loadGameWithExistingLevel encodedLevel ( model, cmd )
        else
            loadGameWithNewLevel encodedLevel ( model, cmd )


loadGameWithExistingLevel : EncodedLevel -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
loadGameWithExistingLevel level ( model, cmd ) =
    let
        modelWithGame =
            loadGameWithLevel level model

        levelIndex =
            LevelCollection.getIndexOf level model.levels
    in
        ( { modelWithGame
            | currentLevelIndex = levelIndex
          }
        , cmd
        )


loadGameWithNewLevel : EncodedLevel -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
loadGameWithNewLevel level ( model, cmd ) =
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
        , Cmd.batch
            [ cmd
            , Storage.storeLevels newLevels
            ]
        )


{-| only load new level and reset all related model props
-}
loadGameWithLevel : EncodedLevel -> Model -> Model
loadGameWithLevel encodedLevel model =
    let
        viewLevel =
            getViewLevelFromEncodedLevel encodedLevel
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , lastMoveDirection = Down
        , levels = model.levels -- not updated here
        , currentEncodedLevel = encodedLevel
        , currentLevelIndex = model.currentLevelIndex -- not updated here
        , movesCount = 0
        , history = []
        , currentPage = GamePage
        , stringLevelFromUserInput = ""
        , levelsData = model.levelsData
        , windowSize = model.windowSize
        , lastTouch = model.lastTouch
        }


{-| only when init the app
-}
initModel : Flags -> Maybe LevelCollection -> LevelDataCollection -> ( Model, Cmd Msg )
initModel flags maybeLevels levelsData =
    let
        levels =
            case maybeLevels of
                Just maybeLevels ->
                    maybeLevels

                Nothing ->
                    LevelCollection.getInitialLevels
    in
        ( { player = Block 0 0
          , walls = []
          , boxes = []
          , dots = []
          , gameSize = ( 0, 0 )
          , isWin = False
          , lastMoveDirection = Down
          , levels = levels -- important here
          , currentEncodedLevel = ""
          , currentLevelIndex = 0
          , movesCount = 0
          , history = []
          , currentPage = HomePage
          , stringLevelFromUserInput = ""
          , levelsData = levelsData
          , windowSize = Window.Size 0 0
          , lastTouch = TouchEvents.Touch 0 0
          }
        , Task.perform WindowSizeUpdated Window.size
        )
