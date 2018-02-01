module Update exposing (update)

import Set exposing (Set)
import Dict
import Navigation
import Types
    exposing
        ( Model
        , Msg(..)
        , Block
        , EncodedLevel
        , GameState
        , Page(..)
        , LevelData
        , MoveDirection(..)
        )
import LevelCollection
import Storage
import Level exposing (getEncodedLevelFromString)
import TouchEvents
import Router


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Move direction ->
            let
                newModel =
                    model
                        |> addToHistory
                        |> movePlayer direction
                        |> moveBoxes direction
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

        ShowPage page ->
            Router.go page model

        RestartLevel ->
            loadLevel model.currentLevelIndex model

        LoadNextLevel ->
            loadLevel (model.currentLevelIndex + 1) model

        LoadLevel levelIndex ->
            loadLevel levelIndex model

        AddLevel levelId ->
            let
                newModel =
                    { model | levels = LevelCollection.appendLevel levelId model.levels }
            in
                ( newModel
                , Storage.storeLevels newModel.levels
                )

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
            Router.match newLocation ( model, Cmd.none )

        WindowSizeUpdated windowSize ->
            ( { model | windowSize = windowSize }
            , Cmd.none
            )

        OnTouchStart touchEvent ->
            ( { model | lastTouch = touchEvent }
            , Cmd.none
            )

        OnTouchEnd touchEvent ->
            let
                swipeDirection =
                    TouchEvents.getDirection model.lastTouch touchEvent
            in
                case swipeDirection of
                    Just TouchEvents.Left ->
                        update (Move Left) model

                    Just TouchEvents.Up ->
                        update (Move Up) model

                    Just TouchEvents.Right ->
                        update (Move Right) model

                    Just TouchEvents.Down ->
                        update (Move Down) model

                    Nothing ->
                        ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


directionToDelta : MoveDirection -> ( Int, Int )
directionToDelta direction =
    case direction of
        Left ->
            ( -1, 0 )

        Right ->
            ( 1, 0 )

        Up ->
            ( 0, -1 )

        Down ->
            ( 0, 1 )


moveBlock : MoveDirection -> Block -> Block
moveBlock direction { x, y } =
    let
        ( deltaX, deltaY ) =
            directionToDelta direction
    in
        { x = x + deltaX, y = y + deltaY }


movePlayer : MoveDirection -> Model -> Model
movePlayer direction model =
    { model
        | player = moveBlock direction model.player
        , lastMoveDirection = direction
        , movesCount = model.movesCount + 1
    }


moveBoxes : MoveDirection -> Model -> Model
moveBoxes direction model =
    let
        moveBox box =
            if box == model.player then
                moveBlock direction box
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
            , lastMoveDirection = model.lastMoveDirection
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
                    , lastMoveDirection = prevGameState.lastMoveDirection
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
