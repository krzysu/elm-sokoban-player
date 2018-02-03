module View exposing (view, getGameBlockSize)

import Html exposing (Html, div, button, h1, textarea, a)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class)
import Svg exposing (Svg, svg, node)
import Svg.Attributes
import Dict
import Window
import Types exposing (Model, Msg(..), Block, IViewLevel, Level, LevelData, Page(..), MoveDirection(..))
import Views.LevelView as LevelView
import Views.HomePage as HomePage
import Views.PlaylistPage as PlaylistPage
import Views.MoreLevelsPage as MoreLevelsPage
import Views.UI as UI
import Views.StatsView as StatsView


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
            HomePage.render model

        PlaylistPage ->
            PlaylistPage.render model

        MoreLevelsPage ->
            MoreLevelsPage.render model


gamePage : Model -> Html Msg
gamePage model =
    div [ class "game" ]
        [ div
            [ class "game__container" ]
            [ LevelView.renderLevelWithDirection
                model.lastMoveDirection
                (getGameBlockSize model.windowSize model.gameSize)
                model
            ]
        , div [ class "game-hud" ]
            [ div [ class "game-hud__stats" ]
                [ StatsView.stats model ]
            , div [ class "page__top-left" ]
                [ UI.buttonWithIcon (ShowPage PlaylistPage) "#iconList" "menu"
                ]
            , div [ class "page__top-right" ]
                [ UI.buttonWithIcon RestartLevel "#iconRestart" "restart (esc)"
                ]
            , div [ class "page__bottom-left" ]
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
                [ Svg.Attributes.xlinkHref "#iconUndo" ]
                []
            ]
        ]


onScreenControls : Html Msg
onScreenControls =
    div [ class "page__bottom-right on-screen-controls" ]
        [ UI.buttonWithIcon (Move Up) "#iconUp" ""
        , div [ class "on-screen-controls__buttons" ]
            [ UI.buttonWithIcon (Move Left) "#iconLeft" ""
            , UI.buttonWithIcon (Move Down) "#iconDown" ""
            , UI.buttonWithIcon (Move Right) "#iconRight" ""
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
                , UI.button LoadNextLevel "next"
                ]
            ]
    else
        Html.text ""


winOverlayStats : Model -> Html Msg
winOverlayStats model =
    let
        stats =
            [ "moves: " ++ (toString model.movesCount)
            , StatsView.bestMovesCount (Dict.get model.currentEncodedLevel model.levelsData)
            ]
    in
        div [ class "text margin" ]
            [ Html.text (String.join " | " stats)
            ]
