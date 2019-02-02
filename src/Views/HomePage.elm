module Views.HomePage exposing (render)

import Html exposing (Html, div, span, h1, h2, p, a, span)
import Html.Attributes exposing (class)
import Array
import Markdown
import Window
import Types exposing (Model, Msg(..), LevelCollection, EncodedLevel, IViewLevel, Page(..))
import Level
import MoreLevelsCollection
import Views.LevelView as LevelView
import Views.UI as UI


type alias Config =
    { maxBlockSize : Float
    }


config : Config
config =
    { maxBlockSize = 30
    }


render : Model -> Html Msg
render model =
    div [ class "page homepage" ]
        [ header
        , div [ class "homepage-content" ]
            [ div [ class "page-width" ]
                [ randomLevelSection model
                , featuresSection
                ]
            ]
        , footer
        ]


header : Html Msg
header =
    div [ class "homepage-header" ]
        [ div [ class "page-width" ]
            [ h1 []
                [ Html.text "Sokoban Player"
                , span [ class "homepage-header__subtitle" ] [ Html.text "play any Sokoban level you want!" ]
                ]
            ]
        ]


randomLevelSection : Model -> Html Msg
randomLevelSection model =
    let
        randomLevelId =
            MoreLevelsCollection.getLevels
                |> Array.get model.randomLevelIndex
                |> Maybe.withDefault ""
    in
        div [ class "homepage-random-level section" ]
            [ div [ class "section-item" ]
                [ h2 [ class "margin headline" ] [ Html.text "Random level for you" ]
                , levelItem randomLevelId model.windowSize
                ]
            , div [ class "section-item homepage-random-level__buttons" ]
                [ div
                    [ class "button-group" ]
                    [ UI.button (LoadLevel randomLevelId) "play it now"
                    , span [] [ Html.text "or" ]
                    , UI.button (ShowPage PlaylistPage) "see your playlist"
                    ]
                ]
            ]


levelItem : EncodedLevel -> Window.Size -> Html Msg
levelItem levelId windowSize =
    let
        viewLevel =
            Level.getViewLevelFromEncodedLevel levelId

        blockSize =
            Level.getGameBlockSize windowSize viewLevel.gameSize config.maxBlockSize
    in
        div [ class "level-item" ]
            [ div
                [ class "level-item__level"
                ]
                [ LevelView.renderLevel blockSize viewLevel
                ]
            ]


featuresSection : Html Msg
featuresSection =
    div [ class "section section--with-3-items" ]
        [ div [ class "section-item" ]
            [ h2 [ class "headline" ] [ Html.text "build and manage your playlist" ]
            , p []
                [ Html.text "play any level you want, just insert it in the "
                , a
                    [ Html.Attributes.href "https://github.com/krzysu/elm-sokoban-player/wiki/Sokoban-Level-Format"
                    , Html.Attributes.target "_blank"
                    ]
                    [ Html.text "Sokoban Level Format" ]
                ]
            ]
        , div [ class "section-item" ]
            [ h2 [ class "headline" ] [ Html.text "take it with you everywhere" ]
            , p [] [ Html.text "works perfectly offline and on mobile devices" ]
            ]
        , div [ class "section-item" ]
            [ h2 [ class "headline" ] [ Html.text "no login or account required" ]
            , p [] [ Html.text "your levels and scores are stored only in your browser, on your own device" ]
            ]
        ]


footer : Html Msg
footer =
    div [ class "homepage-footer" ]
        [ Markdown.toHtml [ class "page-width" ]
            """
designed and built by [Kris Urbas @krzysu](https://www.krisurbas.pl), Berlin 2018
<br>
feedback is welcomed! write me by email or [twitter](https://twitter.com/krzysu)
"""
        ]
