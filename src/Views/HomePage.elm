module Views.HomePage exposing (render)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Types exposing (Model, Msg(..))


render : Model -> Html Msg
render model =
    div [ class "page" ]
        [ Html.text "Sokoban Player"
        ]
