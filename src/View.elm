module View exposing (view, getGameBlockSize)

import Html exposing (Html, div, button, h1, textarea, a)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class)
import Svg exposing (Svg, svg, node)
import Svg.Attributes
import Array exposing (Array)
import Dict
import Window
import Types exposing (Model, Msg(..), Block, IViewLevel, Level, LevelData, Page(..), MoveDirection(..))
import TouchEvents
import LevelView
import HomePage
import PlaylistPage
import MoreLevelsPage


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

        HomePage ->
            -- HomePage.render model
            PlaylistPage.render model

        PlaylistPage ->
            PlaylistPage.render model

        MoreLevelsPage ->
            MoreLevelsPage.render model


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
            , div [ class "game-hud__top-left" ]
                [ buttonWithIcon (ShowPage PlaylistPage) "#hudMenu" "menu"
                ]
            , div [ class "game-hud__top-right" ]
                [ buttonWithIcon RestartLevel "#hudRestart" "restart (esc)"
                ]
            , div [ class "game-hud__bottom-left" ]
                [ undoButton model
                ]
            , onScreenControls
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


undoButton : Model -> Html Msg
undoButton model =
    button
        [ class "button"
        , onClick Undo
        , Html.Attributes.disabled (List.isEmpty model.history)
        , Html.Attributes.title "undo move (u)"
        ]
        [ svg [ Svg.Attributes.class "button__icon" ]
            [ node "use"
                [ Svg.Attributes.xlinkHref "#hudUndo" ]
                []
            ]
        ]


onScreenControls : Html Msg
onScreenControls =
    div [ class "game-hud__bottom-right on-screen-controls" ]
        [ buttonWithIcon (Move Up) "#hudUp" ""
        , div [ class "on-screen-controls__buttons" ]
            [ buttonWithIcon (Move Left) "#hudLeft" ""
            , buttonWithIcon (Move Down) "#hudDown" ""
            , buttonWithIcon (Move Right) "#hudRight" ""
            ]
        ]


buttonWithIcon : Msg -> String -> String -> Svg Msg
buttonWithIcon msg svgId text =
    button
        [ class "button"
        , onClick msg
        , Html.Attributes.title text
        ]
        [ svg [ Svg.Attributes.class "button__icon" ]
            [ node "use"
                [ Svg.Attributes.xlinkHref svgId ]
                []
            ]
        ]


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
