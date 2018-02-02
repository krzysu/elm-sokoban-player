module PlaylistPage exposing (render)

import Html exposing (Html, div, button, h1, textarea, a)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class)
import Array
import Dict
import Markdown
import Level exposing (getViewLevelFromEncodedLevel)
import Types exposing (Model, Msg(..), IViewLevel, LevelData, Page(..))
import LevelView
import StatsView
import UI


render : Model -> Html Msg
render model =
    div [ class "page" ]
        [ div [ class "page-header" ]
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
        , moreLevelsButton
        , footer
        ]


levelItem : ( String, IViewLevel a, Maybe LevelData ) -> Html Msg
levelItem ( levelId, viewLevel, maybeLevelData ) =
    div [ class "level-list-item" ]
        [ div
            [ class "level-list-item__level"
            , onClick (LoadLevel levelId)
            ]
            [ LevelView.renderLevel 20 viewLevel
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


moreLevelsButton : Html Msg
moreLevelsButton =
    div [ class "centered button-group margin" ]
        [ button
            [ class "button"
            , onClick (ShowPage MoreLevelsPage)
            ]
            [ Html.text "or pick from the list" ]
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
