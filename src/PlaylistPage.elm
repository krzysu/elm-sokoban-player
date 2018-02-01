module PlaylistPage exposing (render)

import Html exposing (Html, div, button, h1, textarea, a)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class)
import Array
import Dict
import Markdown
import Level exposing (getViewLevelFromEncodedLevel)
import Types exposing (Model, Msg(..), IViewLevel, LevelData)
import LevelView
import StatsView


type alias Config =
    { previewBlockSize : Int
    }


config : Config
config =
    { previewBlockSize = 20
    }


render : Model -> Html Msg
render model =
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
                [ Html.text (StatsView.bestMovesCount maybeLevelData)
                ]
            ]
        , button
            [ class "button level-preview-item__delete-button"
            , onClick (RemoveLevel levelId)
            ]
            [ Html.text "X" ]
        ]


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
