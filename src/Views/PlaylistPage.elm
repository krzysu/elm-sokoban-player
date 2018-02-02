module Views.PlaylistPage exposing (render)

import Html exposing (Html, div, button, h1, textarea, a)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class)
import Array
import Dict
import Level exposing (getViewLevelFromEncodedLevel)
import Types exposing (Model, Msg(..), IViewLevel, LevelData, Page(..), Overlay(..))
import Views.LevelView as LevelView
import Views.UI as UI
import Views.StatsView as StatsView
import Views.OverlayView as OverlayView


render : Model -> Html Msg
render model =
    div [ class "page" ]
        [ div [ class "page__top-right not-sticky" ]
            [ UI.buttonWithIcon (ShowOverlay InfoOverlay) "#iconInfo" "info"
            ]
        , div [ class "page__top-left" ]
            [ UI.buttonWithIcon (ShowPage HomePage) "#iconHome" "home"
            ]
        , div [ class "page-header" ]
            [ h1 [ class "headline" ] [ Html.text "Your playlist" ]
            , div [ class "text" ] [ Html.text "add and remove levels or click one to play it" ]
            ]
        , div [ class "level-list" ]
            (model.levels
                |> Array.map
                    (\encodedLevel ->
                        ( encodedLevel
                        , getViewLevelFromEncodedLevel encodedLevel
                        , Dict.get encodedLevel model.levelsData
                        )
                    )
                |> Array.map levelItem
                |> Array.toList
            )
        , userLevelInput model
        , OverlayView.overlayManager model
        ]


levelItem : ( String, IViewLevel a, Maybe LevelData ) -> Html Msg
levelItem ( levelId, viewLevel, maybeLevelData ) =
    div [ class "level-list-item" ]
        [ div
            [ class "level-list-item__level"
            , onClick (LoadLevel levelId)
            ]
            [ LevelView.renderLevel 18 viewLevel
            , div [ class "centered" ]
                [ Html.text (StatsView.bestMovesCount maybeLevelData)
                ]
            ]
        , div [ class "level-list-item__button" ]
            [ UI.button (RemoveLevel levelId) "X"
            ]
        ]


userLevelInput : Model -> Html Msg
userLevelInput model =
    div [ class "page-width add-level-section" ]
        [ div [ class "label" ]
            [ Html.text "add new level in "
            , a
                [ Html.Attributes.href "http://sokobano.de/wiki/index.php?title=Level_format"
                , Html.Attributes.target "_blank"
                ]
                [ Html.text "Sokoban Level Format" ]
            ]
        , textarea
            [ class "input level-input margin"
            , onInput ChangeLevelFromUserInput
            , Html.Attributes.placeholder "insert your sokoban level"
            , Html.Attributes.value model.stringLevelFromUserInput
            ]
            []
        , div [ class "centered button-group margin" ]
            [ UI.button AddLevelFromUserInput "add level"
            , Html.text "or"
            , UI.button (ShowPage MoreLevelsPage) "pick from the list"
            ]
        ]
