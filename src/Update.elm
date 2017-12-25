module Update exposing (update)

import Set exposing (Set)
import Types exposing (Model, Msg, Block)
import Model exposing (initModelWithLevelNumber)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Types.Move deltaX deltaY ->
            ( model
                |> movePlayer deltaX deltaY
                |> moveBoxes deltaX deltaY
                |> checkCollisions
                |> Maybe.map checkIfWin
                |> Maybe.withDefault model
            , Cmd.none
            )

        Types.LoadLevel levelNumber ->
            ( initModelWithLevelNumber levelNumber
            , Cmd.none
            )

        Types.NoOp ->
            ( model, Cmd.none )


moveBlock : Int -> Int -> Block -> Block
moveBlock deltaX deltaY { x, y } =
    { x = x + deltaX, y = y + deltaY }


movePlayer : Int -> Int -> Model -> Model
movePlayer deltaX deltaY model =
    { model | player = moveBlock deltaX deltaY model.player }


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
