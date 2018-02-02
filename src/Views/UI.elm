module Views.UI exposing (button, buttonWithIcon)

import Html exposing (Html)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Svg exposing (Svg, svg, node)
import Svg.Attributes
import Types exposing (Model, Msg(..))


button : Msg -> String -> Svg Msg
button msg text =
    Html.button
        [ class "button"
        , onClick msg
        ]
        [ Html.text text ]


buttonWithIcon : Msg -> String -> String -> Svg Msg
buttonWithIcon msg svgId text =
    Html.button
        [ class "button"
        , onClick msg
        , Html.Attributes.title text
        ]
        [ svg [ Svg.Attributes.class "button__icon" ]
            [ node "use"
                [ Svg.Attributes.xlinkHref svgId ]
                []
            ]
        ]
