module Update exposing (update)

import Set exposing (Set)
import Dict
import Navigation
import Types exposing (Model, Msg(..), Block, EncodedLevel, GameState, Page(..), LevelData)
import LevelCollection
import Storage
import Model
import Level exposing (getEncodedLevelFromString)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Move deltaX deltaY ->
            let
                newModel =
                    model
                        |> addToHistory
                        |> movePlayer deltaX deltaY
                        |> moveBoxes deltaX deltaY
                        |> checkCollisions
                        |> Maybe.map checkIfWin
                        |> Maybe.map storeLevelData
                        |> Maybe.withDefault model
            in
                if newModel.isWin then
                    ( newModel
                    , Storage.storeLevelsData newModel.levelsData
                    )
                else
                    ( newModel, Cmd.none )

        Undo ->
            ( model
                |> undoLastMove
            , Cmd.none
            )

        ShowLevelSelectPage ->
            ( model, Navigation.newUrl "/" )

        RestartLevel ->
            loadLevel model.currentLevelIndex model

        LoadNextLevel ->
            loadLevel (model.currentLevelIndex + 1) model

        LoadLevel levelIndex ->
            loadLevel levelIndex model

        RemoveLevel levelId ->
            let
                newModel =
                    { model | levels = LevelCollection.removeLevel levelId model.levels }
            in
                ( newModel
                , Storage.storeLevels newModel.levels
                )

        ChangeLevelFromUserInput input ->
            ( { model | stringLevelFromUserInput = input }
            , Cmd.none
            )

        AddLevelFromUserInput ->
            let
                encodedLevel =
                    model.stringLevelFromUserInput
                        |> getEncodedLevelFromString
            in
                case encodedLevel of
                    Just encodedLevel ->
                        addLevelFromUserInput encodedLevel model

                    Nothing ->
                        ( { model
                            | stringLevelFromUserInput = ""
                          }
                        , Cmd.none
                        )

        UrlChange newLocation ->
            Model.updateModelFromLocation newLocation model

        NoOp ->
            ( model, Cmd.none )


moveBlock : Int -> Int -> Block -> Block
moveBlock deltaX deltaY { x, y } =
    { x = x + deltaX, y = y + deltaY }


movePlayer : Int -> Int -> Model -> Model
movePlayer deltaX deltaY model =
    { model
        | player = moveBlock deltaX deltaY model.player
        , movesCount = model.movesCount + 1
    }


moveBoxes : Int -> Int -> Model -> Model
moveBoxes deltaX deltaY model =
    let
        moveBox box =
            if box == model.player then
                moveBlock deltaX deltaY box
            else
                box
    in
        { model | boxes = List.map moveBox model.boxes }


checkCollisions : Model -> Maybe Model
checkCollisions model =
    if findDuplicatesInList Set.empty ([ model.player ] ++ model.walls ++ model.boxes) then
        Nothing
    else
        Just model


findDuplicatesInList : Set ( Int, Int ) -> List Block -> Bool
findDuplicatesInList checked list =
    case list of
        [] ->
            False

        el :: rest ->
            if Set.member ( el.x, el.y ) checked then
                True
            else
                findDuplicatesInList (Set.insert ( el.x, el.y ) checked) rest


checkIfWin : Model -> Model
checkIfWin model =
    let
        boxes =
            List.map (\{ x, y } -> ( x, y )) model.boxes
                |> Set.fromList

        dots =
            List.map (\{ x, y } -> ( x, y )) model.dots
                |> Set.fromList
    in
        if Set.isEmpty (Set.diff boxes dots) then
            { model | isWin = True }
        else
            model


storeLevelData : Model -> Model
storeLevelData model =
    if model.isWin then
        let
            levelsData =
                Dict.insert
                    model.currentEncodedLevel
                    (LevelData model.movesCount)
                    model.levelsData
        in
            { model | levelsData = levelsData }
    else
        model


addToHistory : Model -> Model
addToHistory model =
    let
        newGameState : GameState
        newGameState =
            { player = model.player
            , boxes = model.boxes
            }

        {- limit -}
        maxHistoryItems =
            100
    in
        { model | history = List.take maxHistoryItems (newGameState :: model.history) }


undoLastMove : Model -> Model
undoLastMove model =
    let
        prevGameState : Maybe GameState
        prevGameState =
            List.head model.history

        restOfHistory =
            List.tail model.history
    in
        case prevGameState of
            Nothing ->
                model

            Just prevGameState ->
                { model
                    | player = prevGameState.player
                    , boxes = prevGameState.boxes
                    , movesCount = model.movesCount - 1
                    , history = Maybe.withDefault [] restOfHistory
                }


loadLevel : Int -> Model -> ( Model, Cmd Msg )
loadLevel levelIndex model =
    let
        pathNameLevel =
            LevelCollection.getLevel levelIndex model.levels
                |> (++) "/"
    in
        ( model, Navigation.newUrl pathNameLevel )


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
