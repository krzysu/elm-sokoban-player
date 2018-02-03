module Views.HomePage exposing (render)

import Html exposing (Html, div, span, h1, h2, p, a)
import Html.Attributes exposing (class)
import Types exposing (Model, Msg(..), LevelCollection, EncodedLevel, IViewLevel, Page(..))
import Level exposing (getViewLevelFromEncodedLevel)
import MoreLevelsCollection
import Views.LevelView as LevelView
import Views.UI as UI
import Array
import Markdown


render : Model -> Html Msg
render model =
    div [ class "page homepage" ]
        [ header
        , div [ class "homepage-content" ]
            [ div [ class "page-width" ]
                [ randomLevelSection model.randomLevelIndex
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


randomLevelSection : Int -> Html Msg
randomLevelSection randomLevelIndex =
    let
        randomLevelId =
            MoreLevelsCollection.getLevels
                |> Array.get randomLevelIndex
                |> Maybe.withDefault ""
    in
        div [ class "homepage-random-level section" ]
            [ div [ class "section-item" ]
                [ h2 [ class "margin headline" ] [ Html.text "Random level for you" ]
                , levelItem randomLevelId
                ]
            , div [ class "section-item homepage-random-level__buttons" ]
                [ div
                    [ class "button-group" ]
                    [ UI.button (LoadLevel randomLevelId) "play it now"
                    , Html.text "or"
                    , UI.button (ShowPage PlaylistPage) "see your playlist"
                    ]
                ]
            ]


levelItem : EncodedLevel -> Html Msg
levelItem levelId =
    let
        viewLevel =
            getViewLevelFromEncodedLevel levelId
    in
        div [ class "level-item" ]
            [ div
                [ class "level-item__level"
                ]
                [ LevelView.renderLevel 25 viewLevel
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
designed and built by [Kris Urbas @krzysu](https://blog.myviews.pl), Berlin 2018
<br>
feedback is welcomed! write me by email or [twitter](https://twitter.com/krzysu)
"""
        ]
