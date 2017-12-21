module Main exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Keyboard
import Dict
import Set exposing (Set)
import Xml exposing (Value)
import Xml.Encode exposing (null)
import Xml.Decode exposing (decode)
import Xml.Query exposing (tags, tag, collect)


---- MODEL ----


type alias Config =
    { blockSize : Int
    , svgSpritePath : String
    }


config : Config
config =
    { blockSize = 80
    , svgSpritePath = "sokoban.sprite.svg"
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


xmlLevel : String
xmlLevel =
    """
     <Level Id="soko42" Width="7" Height="9">
      <L> ######</L>
      <L> #    #</L>
      <L>## $  #</L>
      <L>#  ##$#</L>
      <L># $.#.#</L>
      <L># $...#</L>
      <L># $####</L>
      <L>#@ #</L>
      <L>####</L>
    </Level>
"""


decodedXmlLevel : Value
decodedXmlLevel =
    xmlLevel
        |> decode
        |> Result.toMaybe
        |> Maybe.withDefault null


xmlLevelMap : List (List Char)
xmlLevelMap =
    tags "L" decodedXmlLevel
        |> collect (tag "L" Xml.Query.string)
        |> List.map String.toList


xmlLevelSize : ( Int, Int )
xmlLevelSize =
    case List.head (tags "Level" decodedXmlLevel) of
        Just (Xml.Tag _ attrs _) ->
            ( getIntAttr attrs "Width", getIntAttr attrs "Height" )

        _ ->
            ( 0, 0 )


getIntAttr : Dict.Dict String Value -> String -> Int
getIntAttr attrs attrName =
    Dict.get attrName attrs
        |> Maybe.map valueToString
        |> Maybe.withDefault 0


valueToString : Value -> Int
valueToString value =
    case value of
        Xml.IntNode a ->
            a

        _ ->
            0


level2 : Level
level2 =
    { width = Tuple.first (xmlLevelSize)
    , height = Tuple.second (xmlLevelSize)
    , map = xmlLevelMap
    }



-- url.com?level=######@$.######&width=3


initLevel : Level -> Model
initLevel level =
    { player = Maybe.withDefault (Block 0 0) <| List.head (levelToBlocks level [ '@', '+' ])
    , walls = levelToBlocks level [ '#' ]
    , boxes = levelToBlocks level [ '$', '*' ]
    , dots = levelToBlocks level [ '.', '+', '*' ]
    , isWin = False
    , gameSize = ( level.width, level.height )
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
    ( initLevel level2
    , Cmd.none
    )



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
        [ width (toString (Tuple.first model.gameSize * config.blockSize))
        , height (toString (Tuple.second model.gameSize * config.blockSize))
        , class "game-arena"
        ]
        (List.concat
            [ List.map (renderBlockById "#wallRed") model.walls
            , List.map (renderBlockById "#dotGreen") model.dots
            , List.map (renderBlockById "#boxGreen") model.boxes
            , [ renderBlockById "#playerFront" model.player ]
            ]
        )


getBlockPositionAndSize : Block -> { x : Int, y : Int, size : Int }
getBlockPositionAndSize block =
    let
        posX =
            block.x * config.blockSize

        posY =
            block.y * config.blockSize

        renderedBlockSize =
            config.blockSize
    in
        { x = posX
        , y = posY
        , size = renderedBlockSize
        }


renderBlock : String -> Block -> Svg Msg
renderBlock color block =
    let
        blockPosition =
            getBlockPositionAndSize block

        blockRadius =
            toString (round (toFloat config.blockSize / 8))
    in
        rect
            [ x (toString blockPosition.x)
            , y (toString blockPosition.y)
            , width (toString blockPosition.size)
            , height (toString blockPosition.size)
            , fill color
            , rx blockRadius
            , ry blockRadius
            ]
            []


renderBlockById : String -> Block -> Svg Msg
renderBlockById svgId block =
    let
        blockPosition =
            getBlockPositionAndSize block
    in
        svg
            [ x (toString blockPosition.x)
            , y (toString blockPosition.y)
            , width (toString blockPosition.size)
            , height (toString blockPosition.size)
            ]
            [ node "use"
                [ xlinkHref (config.svgSpritePath ++ svgId) ]
                []
            ]



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
