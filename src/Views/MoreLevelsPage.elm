module Views.MoreLevelsPage exposing (render)

import Html exposing (Html, div, h1)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Array
import Set
import Types exposing (Model, Msg(..), LevelCollection, EncodedLevel, IViewLevel, LevelData, Page(..), Overlay(..))
import Level exposing (getViewLevelFromEncodedLevel)
import MoreLevelsCollection
import Views.LevelView as LevelView
import Views.UI as UI
import Views.OverlayView as OverlayView


render : Model -> Html Msg
render model =
    div [ class "page" ]
        [ div [ class "page__top-left" ]
            [ UI.buttonWithIcon (ShowPage PlaylistPage) "#iconList" "menu"
            ]
        , div [ class "page__top-right page-region--not-sticky" ]
            [ UI.buttonWithIcon (ShowOverlay InfoOverlay) "#iconInfo" "info"
            ]
        , div [ class "page-header" ]
            [ h1 [ class "headline" ] [ Html.text "Sokoban Original Levels" ]
            , div [ class "text" ]
                [ Html.text "add new levels to your playlist" ]
            ]
        , div [ class "level-list" ]
            (MoreLevelsCollection.getLevels
                |> filterOutLevelsAlreadyInPlaylist model.levels
                |> Array.toList
                -- TODO pagination
                |> List.take 10
                |> List.map
                    (\encodedLevel ->
                        ( encodedLevel
                        , getViewLevelFromEncodedLevel encodedLevel
                        )
                    )
                |> List.map levelItem
            )
        , OverlayView.overlayManager model
        ]


filterOutLevelsAlreadyInPlaylist : LevelCollection -> LevelCollection -> LevelCollection
filterOutLevelsAlreadyInPlaylist playlistLevels moreLevels =
    let
        playlistSet =
            playlistLevels
                |> Array.toList
                |> Set.fromList
    in
        moreLevels
            |> Array.filter (\levelId -> not (Set.member levelId playlistSet))


levelItem : ( String, IViewLevel a ) -> Html Msg
levelItem ( levelId, viewLevel ) =
    div [ class "level-list-item" ]
        [ div
            [ class "level-list-item__level"
            , onClick (LoadLevel levelId)
            ]
            [ LevelView.renderLevel 18 viewLevel
            ]
        , div [ class "level-list-item__button" ]
            [ UI.buttonWithIcon (AddLevel levelId) "#iconAdd" "add"
            ]
        ]
