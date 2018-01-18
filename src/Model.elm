module Model exposing (initModel, updateModelFromLocation, addLevelFromUserInput)

import Navigation exposing (Location)
import Types exposing (Model, Msg, Block, EncodedLevel, LevelCollection, Page(..))
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
                let
                    newModel =
                        encodedLevel
                            |> updateModelWithNewLevel model
                in
                    ( newModel
                    , Storage.storeLevels newModel.levels
                    )

            Nothing ->
                ( { model | currentPage = LevelSelectPage }
                , Cmd.none
                )


updateModelWithNewLevel : Model -> EncodedLevel -> Model
updateModelWithNewLevel model encodedLevel =
    let
        -- TODO if level exists, then currentLevelIndex is wrong
        viewLevel =
            getViewLevelFromEncodedLevel encodedLevel

        newLevels =
            LevelCollection.prependLevel encodedLevel model.levels
    in
        { player = viewLevel.player
        , walls = viewLevel.walls
        , boxes = viewLevel.boxes
        , dots = viewLevel.dots
        , gameSize = viewLevel.gameSize
        , isWin = False
        , levels = newLevels
        , currentLevelIndex = 0
        , movesCount = 0
        , history = []
        , currentPage = GamePage
        , stringLevelFromUserInput = ""
        }


initModel : Maybe LevelCollection -> Model
initModel maybeLevels =
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
        , history = []
        , currentPage = LevelSelectPage
        , stringLevelFromUserInput = ""
        }


addLevelFromUserInput : EncodedLevel -> Model -> ( Model, Cmd Msg )
addLevelFromUserInput encodedLevel model =
    let
        newLevels =
            LevelCollection.appendLevel encodedLevel model.levels
    in
        ( { model
            | levels = newLevels
            , stringLevelFromUserInput = ""
          }
        , Storage.storeLevels newLevels
        )
