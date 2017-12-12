module Main exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Keyboard
import Set exposing (Set)


---- MODEL ----


type alias Config =
    { gameArenaSize : Int
    , blockSize : Int
    }


config : Config
config =
    { gameArenaSize = 11
    , blockSize = 60
    }


type alias Block =
    { x : Int
    , y : Int
    }


type alias Model =
    { player : Block
    , walls : List Block
    , boxes : List Block
    , dots : List Block
    , isWin : Bool
    , gameSize : ( Int, Int )
    }


type alias Level =
    { width : Int
    , height : Int
    , map : List (List Char)
    }


level : Level
level =
    { width = 7
    , height = 9
    , map =
        [ [ ' ', ' ', ' ', '#', '#', '#', ' ' ]
        , [ '#', '#', '#', '#', '@', '#', ' ' ]
        , [ '#', '.', ' ', ' ', ' ', '#', '#' ]
        , [ '#', '.', ' ', '*', ' ', ' ', '#' ]
        , [ '#', '.', ' ', '#', '$', ' ', '#' ]
        , [ '#', '#', '$', '#', ' ', ' ', '#' ]
        , [ ' ', '#', ' ', '$', ' ', '#', '#' ]
        , [ ' ', '#', ' ', ' ', ' ', '#', ' ' ]
        , [ ' ', '#', '#', '#', '#', '#', ' ' ]
        ]
    }


initLevel : Level -> Model
initLevel level =
    { player = Maybe.withDefault (Block 0 0) <| List.head (levelToBlocks level [ '@', '+' ])
    , walls = levelToBlocks level [ '#' ]
    , boxes = levelToBlocks level [ '$', '*' ]
    , dots = levelToBlocks level [ '.', '+', '*' ]
    , isWin = False
    , gameSize = ( 10, 10 )
    }


levelToBlocks : Level -> List Char -> List Block
levelToBlocks level entityCharList =
    let
        maybeBlocks =
            List.indexedMap
                (\y row ->
                    List.indexedMap
                        (\x char ->
                            if (List.member char entityCharList) then
                                Just (Block x y)
                            else
                                Nothing
                        )
                        row
                )
                level.map
    in
        maybeBlocks
            |> List.concat
            |> List.filterMap identity


init : ( Model, Cmd Msg )
init =
    ( initLevel level
    , Cmd.none
    )


getGameArena : List Block
getGameArena =
    let
        lengthAsArray =
            List.range 0 (config.gameArenaSize - 1)

        topRow =
            lengthAsArray
                |> List.map (\x -> ( x, 0 ))

        bottomRow =
            lengthAsArray
                |> List.map (\x -> ( x, config.gameArenaSize - 1 ))

        columnAsArray =
            [ 1, 2, 3, config.gameArenaSize - 4, config.gameArenaSize - 3, config.gameArenaSize - 2 ]

        leftColumn =
            columnAsArray
                |> List.map (\y -> ( 0, y ))

        rightColumn =
            columnAsArray
                |> List.map (\y -> ( config.gameArenaSize - 1, y ))

        positions =
            topRow ++ bottomRow ++ leftColumn ++ rightColumn
    in
        positions
            |> List.map (\( x, y ) -> Block x y)



---- UPDATE ----


type Msg
    = NoOp
    | Move Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Move deltaX deltaY ->
            ( model
                |> movePlayer deltaX deltaY
                |> moveBoxes deltaX deltaY
                |> checkCollisions
                |> Maybe.map checkIfWin
                |> Maybe.withDefault model
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )


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


movePlayer : Int -> Int -> Model -> Model
movePlayer deltaX deltaY model =
    { model | player = moveBlock deltaX deltaY model.player }


moveBlock : Int -> Int -> Block -> Block
moveBlock deltaX deltaY { x, y } =
    { x = x + deltaX, y = y + deltaY }


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



---- VIEW ----


view : Model -> Html Msg
view model =
    svg
        [ width (toString (config.gameArenaSize * config.blockSize))
        , height (toString (config.gameArenaSize * config.blockSize))
        , Html.Attributes.style
            [ ( "margin", "10px auto" )
            , ( "display", "block" )
            , ( "background", "#eee" )
            ]
        ]
        (List.concat
            [ List.map (renderBlock "#333") model.walls
            , List.map (renderBlock "#fff") model.dots
            , List.map (renderBlock "green") model.boxes
            , [ renderBlock "#fac" model.player ]
            ]
        )


renderBlock : String -> Block -> Svg Msg
renderBlock color block =
    let
        posX =
            toString (block.x * config.blockSize)

        posY =
            toString (block.y * config.blockSize)

        renderedBlockSize =
            toString (config.blockSize - 1)

        blockRadius =
            toString (round (toFloat config.blockSize / 8))
    in
        rect
            [ x posX
            , y posY
            , width renderedBlockSize
            , height renderedBlockSize
            , fill color
            , rx blockRadius
            , ry blockRadius
            ]
            []



---- subscriptions


arrowChanged : Sub Msg
arrowChanged =
    Keyboard.downs toArrowChanged


toArrowChanged : Keyboard.KeyCode -> Msg
toArrowChanged code =
    case code of
        37 ->
            -- LeftKey
            Move -1 0

        38 ->
            -- UpKey
            Move 0 -1

        39 ->
            -- RightKey
            Move 1 0

        40 ->
            -- DownKey
            Move 0 1

        _ ->
            NoOp


subscriptions : Model -> Sub Msg
subscriptions model =
    arrowChanged



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
