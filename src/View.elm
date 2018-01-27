module View exposing (view, getGameBlockSize)

import Html exposing (Html, text, div, span, button, h1, textarea, a, br)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class)
import Array exposing (Array)
import Dict
import Window
import Level exposing (getViewLevelFromEncodedLevel)
import Types exposing (Model, Msg(..), Block, IViewLevel, Level, LevelData, Page(..), MoveDirection(..))
import TouchEvents
import Json.Decode
import LevelView
import Markdown


type alias Config =
    { maxBlockSize : Float
    , minBlockSize : Float
    , previewBlockSize : Int
    }


config : Config
config =
    { maxBlockSize = 60
    , minBlockSize = 10
    , previewBlockSize = 20
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
    div [ class "game" ]
        [ div
            [ class "game__container"
            , TouchEvents.onTouchEvent TouchEvents.TouchStart OnTouchStart
            , TouchEvents.onTouchEvent TouchEvents.TouchEnd OnTouchEnd
            ]
            [ LevelView.renderLevelWithDirection
                model.lastMoveDirection
                (getGameBlockSize model.windowSize model.gameSize)
                model
            ]
        , div [ class "game-hud" ]
            [ div [ class "game-hud__stats" ]
                [ stats model ]
            , div [ class "game-hud__buttons" ]
                [ div [ class "game-hud__buttons-item" ] [ undoButton model ]
                , div [ class "game-hud__buttons-item" ] [ resetButton ]
                , div [ class "game-hud__buttons-item" ] [ menuButton ]
                ]
            , if model.isTouchDevice then
                onScreenControls
              else
                Html.text ""
            ]
        , winOverlay model
        ]


getGameBlockSize : Window.Size -> ( Int, Int ) -> Int
getGameBlockSize windowSize ( gameWidth, gameHeight ) =
    let
        horizontalSize =
            0.9 * (toFloat windowSize.width) / (toFloat gameWidth)

        verticalSize =
            0.9 * (toFloat windowSize.height) / (toFloat gameHeight)

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
        [ class "button"
        , onClick Undo
        , Html.Attributes.disabled (List.isEmpty model.history)
        ]
        [ Html.text "undo (u)" ]


resetButton : Html Msg
resetButton =
    button
        [ class "button"
        , onClick RestartLevel
        ]
        [ Html.text "restart (esc)" ]


onScreenControls : Html Msg
onScreenControls =
    div [ class "game-hud__controls on-screen-controls" ]
        [ touchButton (Move Up) "up"
        , div [ class "on-screen-controls__buttons" ]
            [ touchButton (Move Left) "left"
            , touchButton (Move Right) "right"
            ]
        , touchButton (Move Down) "down"
        ]


touchButton : Msg -> String -> Html Msg
touchButton msg text =
    button
        [ class "button"
        , onTouchStart msg
        ]
        [ Html.text text ]


onTouchStart : Msg -> Html.Attribute Msg
onTouchStart msg =
    Html.Events.on "touchstart" (Json.Decode.succeed msg)


{-| render overlay with success message
-}
winOverlay : Model -> Html Msg
winOverlay model =
    if model.isWin then
        div [ class "overlay" ]
            [ div [ class "overlay__body" ]
                [ div [ class "ribbon" ]
                    [ Html.text "Solved!" ]
                , winOverlayStats model
                , button
                    [ class "button"
                    , onClick LoadNextLevel
                    ]
                    [ Html.text "next (enter)" ]
                ]
            ]
    else
        Html.text ""


winOverlayStats : Model -> Html Msg
winOverlayStats model =
    let
        stats =
            [ "moves: " ++ (toString model.movesCount)
            , bestMovesCount (Dict.get model.currentEncodedLevel model.levelsData)
            ]
    in
        div [ class "text margin" ]
            [ Html.text (String.join " | " stats)
            ]


menuButton : Html Msg
menuButton =
    button
        [ class "button"
        , onClick (ShowLevelSelectPage)
        ]
        [ Html.text "menu" ]


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
        , footer
        ]


levelPreviewItem : Int -> ( String, IViewLevel a, Maybe LevelData ) -> Html Msg
levelPreviewItem levelIndex ( levelId, viewLevel, maybeLevelData ) =
    div [ class "level-preview-item" ]
        [ div
            [ class "level-preview-item__level"
            , onClick (LoadLevel levelIndex)
            ]
            [ LevelView.renderLevel config.previewBlockSize viewLevel
            , div [ class "centered" ]
                [ Html.text (bestMovesCount maybeLevelData)
                ]
            ]
        , button
            [ class "button level-preview-item__delete-button"
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
                [ class "button"
                , onClick AddLevelFromUserInput
                ]
                [ Html.text "add level" ]
            ]
        ]


footer : Html Msg
footer =
    Markdown.toHtml [ class "footer" ] """
designed and built by [Kris Urbas @krzysu](https://blog.myviews.pl)
with little help from [Elm Berlin](https://www.meetup.com/Elm-Berlin/) meetup group <br>
feedback is welcome! contact me by email or [twitter](https://twitter.com/krzysu)

original Sokoban game written by Hiroyuki Imabayashi © 1982 by THINKING RABBIT Inc. JAPAN

thanks to [Kenney.nl](http://www.kenney.nl/) for free game assets
"""
