module View exposing (view, getGameBlockSize)

import Html exposing (Html, text, div, span, button, h1, textarea, a)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class)
import Svg exposing (Svg, svg, node)
import Svg.Attributes
import Array exposing (Array)
import Set exposing (Set)
import Dict
import Window
import Level exposing (getViewLevelFromEncodedLevel)
import Types exposing (Model, Msg(..), Block, IViewLevel, Level, LevelData, Page(..), MoveDirection(..))
import TouchEvents


type alias Config =
    { maxBlockSize : Float
    , minBlockSize : Float
    , previewBlockSize : Int
    , svgSpritePath : String
    }


config : Config
config =
    { maxBlockSize = 60
    , minBlockSize = 20
    , previewBlockSize = 20
    , svgSpritePath = "sokoban.sprite.svg"
    }


view : Model -> Html Msg
view model =
    case model.currentPage of
        GamePage ->
            gamePage model

        LevelSelectPage ->
            levelSelectPage model


gamePage : Model -> Html Msg
gamePage model =
    div [ class "wrapper" ]
        [ div [ class "header" ]
            [ h1 [ class "headline" ] [ Html.text "Sokoban Player" ]
            , stats model
            ]
        , div
            [ TouchEvents.onTouchEvent TouchEvents.TouchStart OnTouchStart
            , TouchEvents.onTouchEvent TouchEvents.TouchEnd OnTouchEnd
            ]
            [ renderLevelWithDirection model.lastMoveDirection (getGameBlockSize model.windowSize model.gameSize) "game-arena" model
            ]
        , div [ class "button-group margin" ]
            [ undoButton model
            , resetButton
            ]
        , selectLevelButton
        , winOverlay model
        ]


getGameBlockSize : Window.Size -> ( Int, Int ) -> Int
getGameBlockSize windowSize ( gameWidth, gameHeight ) =
    let
        horizontalSize =
            0.9 * (toFloat windowSize.width) / (toFloat gameWidth)

        verticalSize =
            0.8 * (toFloat windowSize.height) / (toFloat gameHeight)

        possibleSize =
            if horizontalSize > verticalSize then
                verticalSize
            else
                horizontalSize
    in
        if possibleSize > config.maxBlockSize then
            round config.maxBlockSize
        else if possibleSize < config.minBlockSize then
            round config.minBlockSize
        else
            round possibleSize


renderLevel : Int -> String -> IViewLevel a -> Html Msg
renderLevel =
    renderLevelWithDirection Down


renderLevelWithDirection : MoveDirection -> Int -> String -> IViewLevel a -> Html Msg
renderLevelWithDirection direction blockSize className viewLevel =
    let
        blockById =
            blockBySizeAndId blockSize
    in
        svg
            [ Svg.Attributes.width (toString (Tuple.first viewLevel.gameSize * blockSize))
            , Svg.Attributes.height (toString (Tuple.second viewLevel.gameSize * blockSize))
            , Svg.Attributes.class className
            ]
            (List.concat
                [ List.map (blockById "#wallBrown") viewLevel.walls
                , List.map (blockById "#dotGreen") viewLevel.dots
                , boxes viewLevel.dots viewLevel.boxes blockById
                , [ player blockById direction viewLevel.player ]
                ]
            )


{-| render by svg sprite id
-}
blockBySizeAndId : Int -> String -> Block -> Svg Msg
blockBySizeAndId blockSize svgId block =
    let
        blockPosition =
            { x = block.x * blockSize
            , y = block.y * blockSize
            }
    in
        node "use"
            [ Svg.Attributes.xlinkHref (config.svgSpritePath ++ svgId)
            , Svg.Attributes.x (toString blockPosition.x)
            , Svg.Attributes.y (toString blockPosition.y)
            , Svg.Attributes.width (toString blockSize)
            , Svg.Attributes.height (toString blockSize)
            ]
            []


boxes : List Block -> List Block -> (String -> Block -> Svg Msg) -> List (Svg Msg)
boxes dotList boxList blockById =
    let
        boxSet =
            blocksToSet boxList

        dotSet =
            blocksToSet dotList

        boxesOverDots =
            Set.intersect boxSet dotSet
                |> setToBlocks

        boxesNotOverDots =
            Set.diff boxSet dotSet
                |> setToBlocks
    in
        List.concat
            [ List.map (blockById "#boxGreenAlt") boxesOverDots
            , List.map (blockById "#boxGreen") boxesNotOverDots
            ]


blocksToSet : List Block -> Set ( Int, Int )
blocksToSet blocks =
    blocks
        |> List.map (\{ x, y } -> ( x, y ))
        |> Set.fromList


setToBlocks : Set ( Int, Int ) -> List Block
setToBlocks set =
    set
        |> Set.toList
        |> List.map (\( x, y ) -> Block x y)


player : (String -> Block -> Svg Msg) -> MoveDirection -> Block -> Svg Msg
player blockById direction block =
    case direction of
        Left ->
            blockById "#playerLeft" block

        Right ->
            blockById "#playerRight" block

        Up ->
            blockById "#playerBack" block

        Down ->
            blockById "#playerFront" block


stats : Model -> Html Msg
stats model =
    let
        stats =
            [ levelCount model
            , "moves: " ++ (toString model.movesCount)
            , bestMovesCount (Dict.get model.currentEncodedLevel model.levelsData)
            ]
    in
        div [ class "text" ]
            [ Html.text (String.join " | " stats)
            ]


levelCount : Model -> String
levelCount model =
    let
        levelsCount =
            toString (Array.length model.levels)

        currentLevel =
            toString (model.currentLevelIndex + 1)
    in
        "level " ++ currentLevel ++ "/" ++ levelsCount


undoButton : Model -> Html Msg
undoButton model =
    button
        [ class "button button--small"
        , onClick Undo
        , Html.Attributes.disabled (List.isEmpty model.history)
        ]
        [ Html.text "undo (u)" ]


resetButton : Html Msg
resetButton =
    button
        [ class "button button--small"
        , onClick RestartLevel
        ]
        [ Html.text "restart (esc)" ]


{-| render overlay with success message
-}
winOverlay : Model -> Html Msg
winOverlay model =
    if model.isWin then
        div []
            [ div [ class "overlay-body" ]
                [ div [ class "ribbon" ]
                    [ Html.text "Solved!" ]
                , button
                    [ class "button margin"
                    , onClick LoadNextLevel
                    ]
                    [ Html.text "next (enter)" ]
                ]
            , div [ class "overlay" ] []
            ]
    else
        Html.text ""


selectLevelButton : Html Msg
selectLevelButton =
    button
        [ class "button button--small margin"
        , onClick (ShowLevelSelectPage)
        ]
        [ Html.text "edit level list" ]


levelSelectPage : Model -> Html Msg
levelSelectPage model =
    div []
        [ div [ class "header" ]
            [ h1 [ class "headline" ] [ Html.text "Edit your playlist" ]
            , div [ class "text" ] [ Html.text "add and remove levels, or click one to play it" ]
            ]
        , div [ class "level-preview-list" ]
            (model.levels
                |> Array.map
                    (\encodedLevel ->
                        ( encodedLevel
                        , getViewLevelFromEncodedLevel encodedLevel
                        , Dict.get encodedLevel model.levelsData
                        )
                    )
                |> Array.indexedMap levelPreviewItem
                |> Array.toList
            )
        , userLevelInput model
        ]


levelPreviewItem : Int -> ( String, IViewLevel a, Maybe LevelData ) -> Html Msg
levelPreviewItem levelIndex ( levelId, viewLevel, maybeLevelData ) =
    div [ class "level-preview-item" ]
        [ div
            [ class "level-preview-item__level"
            , onClick (LoadLevel levelIndex)
            ]
            [ renderLevel config.previewBlockSize "" viewLevel
            , div [ class "centered" ]
                [ Html.text (bestMovesCount maybeLevelData)
                ]
            ]
        , button
            [ class "button button--small level-preview-item__delete-button"
            , onClick (RemoveLevel levelId)
            ]
            [ Html.text "X" ]
        ]


bestMovesCount : Maybe LevelData -> String
bestMovesCount levelData =
    let
        bestMovesCount =
            levelData
                |> Maybe.map .bestMovesCount
                |> Maybe.withDefault 0
                |> toString
    in
        "best score: " ++ bestMovesCount


userLevelInput : Model -> Html Msg
userLevelInput model =
    div [ class "level-input-wrapper margin" ]
        [ div [ class "label" ]
            [ Html.text "add new level in "
            , a
                [ Html.Attributes.href "http://sokobano.de/wiki/index.php?title=Level_format"
                , Html.Attributes.target "_blank"
                ]
                [ Html.text "Sokoban Level Format" ]
            ]
        , textarea
            [ class "input level-input"
            , onInput ChangeLevelFromUserInput
            , Html.Attributes.placeholder "insert your sokoban level"
            , Html.Attributes.value model.stringLevelFromUserInput
            ]
            []
        , div [ class "centered button-group margin" ]
            [ button
                [ class "button button--small"
                , onClick AddLevelFromUserInput
                ]
                [ Html.text "add level" ]
            ]
        ]
