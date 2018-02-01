module MoreLevelsPage exposing (render)

import Html exposing (Html, div, h1)
import Html.Attributes exposing (class)
import Dict
import Array
import Set
import Types exposing (Model, Msg(..), LevelCollection, EncodedLevel, IViewLevel, LevelData, Page(..))
import Level exposing (getViewLevelFromEncodedLevel)
import MoreLevelsCollection
import LevelView
import UI


render : Model -> Html Msg
render model =
    div [ class "page" ]
        [ div [ class "page__top-left" ]
            [ UI.buttonWithIcon (ShowPage PlaylistPage) "#iconList" "menu"
            ]
        , div [ class "page-header" ]
            [ h1 [ class "headline" ] [ Html.text "Sokoban Classic Levels" ]
            , div [ class "text" ]
                [ Html.text "add new levels to your playlist from remaining classic levels" ]
            ]
        , div [ class "level-list" ]
            (MoreLevelsCollection.getLevels
                |> filterOutLevelsAlreadyInPlaylist model.levels
                |> List.map
                    (\encodedLevel ->
                        ( encodedLevel
                        , getViewLevelFromEncodedLevel encodedLevel
                        , Dict.get encodedLevel model.levelsData
                        )
                    )
                |> List.map levelItem
            )
        ]


filterOutLevelsAlreadyInPlaylist : LevelCollection -> LevelCollection -> List EncodedLevel
filterOutLevelsAlreadyInPlaylist playlistLevels moreLevels =
    let
        playlistSet =
            playlistLevels
                |> Array.toList
                |> Set.fromList

        moreLevelsSet =
            moreLevels
                |> Array.toList
                |> Set.fromList
    in
        Set.diff moreLevelsSet playlistSet
            |> Set.toList


levelItem : ( String, IViewLevel a, Maybe LevelData ) -> Html Msg
levelItem ( levelId, viewLevel, maybeLevelData ) =
    div [ class "level-list-item" ]
        [ div [ class "level-list-item__level" ]
            [ LevelView.renderLevel 20 viewLevel
            ]
        , div [ class "level-list-item__button" ]
            [ UI.buttonWithIcon (AddLevel levelId) "#iconAdd" "add"
            ]
        ]
