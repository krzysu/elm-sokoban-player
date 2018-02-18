module Views.OverlayView exposing (overlayManager)

import Html exposing (Html, div, h2, p, input)
import Html.Attributes exposing (class)
import Markdown
import Types exposing (Model, Msg(..), Overlay(..), EncodedLevel)
import Views.UI as UI


overlayManager : Model -> Html Msg
overlayManager model =
    case model.currentOverlay of
        NoOverlay ->
            Html.text ""

        InfoOverlay ->
            infoOverlay

        ShareOverlay ->
            shareOverlay model.currentEncodedLevel

        RestartConfirmOverlay ->
            restartConfirmOverlay


infoOverlay : Html Msg
infoOverlay =
    div [ class "overlay" ]
        [ div [ class "overlay__action" ]
            [ UI.button (ShowOverlay NoOverlay) "X"
            ]
        , div [ class "overlay__body" ]
            [ div [ class "keybinding" ]
                [ h2 [ class "headline centered" ]
                    [ Html.text "Key bindings" ]
                , keybinding
                ]
            , h2 [ class "headline" ]
                [ Html.text "Credits" ]
            , credits
            ]
        ]


shareOverlay : EncodedLevel -> Html Msg
shareOverlay encodedLevel =
    div [ class "overlay" ]
        [ div [ class "overlay__action" ]
            [ UI.button (ShowOverlay NoOverlay) "X"
            ]
        , div [ class "overlay__body" ]
            [ h2 [ class "headline centered" ]
                [ Html.text "Share this level" ]
            , p [ class "centered" ]
                [ Html.text "Just copy the link below and share it anywhere you want" ]
            , input
                [ class "share-input margin"
                , Html.Attributes.type_ "text"
                , Html.Attributes.value ("https://sokoban-player.netlify.com/" ++ encodedLevel)
                ]
                []
            ]
        ]


restartConfirmOverlay : Html Msg
restartConfirmOverlay =
    div [ class "overlay" ]
        [ div [ class "overlay__body" ]
            [ h2 [ class "headline centered" ]
                [ Html.text "Do you want to restart this level?" ]
            , p [ class "centered" ]
                [ Html.text "All progress will be lost" ]
            , div [ class "button-group margin" ]
                [ UI.button (ShowOverlay NoOverlay) "no"
                , UI.button RestartLevel "yes"
                ]
            ]
        ]


keybinding : Html Msg
keybinding =
    Markdown.toHtml [ class "margin centered" ] """
game screen

- u - undo
- esc - restart level
- arrow keys - move player

level solved screen

- enter - next level
"""


credits : Html Msg
credits =
    Markdown.toHtml [ class "centered" ] """
designed and built by [Kris Urbas @krzysu](https://blog.myviews.pl)
with little help from [Elm Berlin](https://www.meetup.com/Elm-Berlin/) meetup group
<br>
feedback is welcomed! contact me by email or [twitter](https://twitter.com/krzysu)

original Sokoban game written by Hiroyuki Imabayashi © 1982 by THINKING RABBIT Inc. JAPAN
<br>
Sokoban Original Levels by Thinking Rabbit
<br>
additional level copyrights may apply, as example see [here](https://sokoban-game.com/packs)

thanks to [Kenney.nl](http://www.kenney.nl/) for free game assets
"""
