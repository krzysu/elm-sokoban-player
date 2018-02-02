module Views.HomePage exposing (render)

import Html exposing (Html, div, span, h1, h2, p)
import Html.Attributes exposing (class)
import Types exposing (Model, Msg(..), LevelCollection, EncodedLevel, IViewLevel, Page(..))
import Level exposing (getViewLevelFromEncodedLevel)
import MoreLevelsCollection
import Views.LevelView as LevelView
import Views.UI as UI
import Array


render : Model -> Html Msg
render model =
    div [ class "page" ]
        [ header
        , div [ class "page-width" ]
            [ randomLevelSection
            ]

        -- TODO
        -- , div [ class "page-width" ]
        --     [ featuresSection
        --     ]
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


randomLevelSection : Html Msg
randomLevelSection =
    let
        randomLevelId =
            MoreLevelsCollection.getLevels
                |> Array.get 1
                |> Maybe.withDefault ""
    in
        div [ class "homepage-random-level section" ]
            [ div [ class "section-item" ]
                [ h2 [ class "margin" ] [ Html.text "Random level for you" ]
                , levelItem randomLevelId
                ]
            , div [ class "section-item homepage-random-level__buttons" ]
                [ div
                    [ class "button-group" ]
                    [ UI.button (LoadLevel randomLevelId) "play now"
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
    div [ class "section" ]
        [ div [ class "section-item" ]
            [ h2 [] [ Html.text "Manage your playlist" ]
            , p [] [ Html.text "lorem ipsum" ]
            , UI.button (ShowPage PlaylistPage) "my playlist"
            ]
        , div [ class "section-item" ]
            [ h2 [] [ Html.text "Manage your playlist" ]
            , p [] [ Html.text "lorem ipsum" ]
            , UI.button (ShowPage PlaylistPage) "my playlist"
            ]
        , div [ class "section-item" ]
            [ h2 [] [ Html.text "Manage your playlist" ]
            , p [] [ Html.text "lorem ipsum" ]
            , UI.button (ShowPage PlaylistPage) "my playlist"
            ]
        ]
