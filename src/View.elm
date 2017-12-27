module View exposing (view)

import Html exposing (Html, text, div, button)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (Model, Msg, Block)


type alias Config =
    { blockSize : Int
    , svgSpritePath : String
    }


config : Config
config =
    { blockSize = 60
    , svgSpritePath = "sokoban.sprite.svg"
    }


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ svg
            [ width (toString (Tuple.first model.gameSize * config.blockSize))
            , height (toString (Tuple.second model.gameSize * config.blockSize))
            , class "game-arena"
            ]
            (List.concat
                [ List.map (renderBlockById "#wallBrown") model.walls
                , List.map (renderBlockById "#dotGreen") model.dots
                , List.map (renderBlockById "#boxGreen") model.boxes
                , [ renderBlockById "#playerFront" model.player ]
                ]
            )
        , getWinRibbon model
        , getMovesCounter model
        ]


{-| helper to get position and size of Block to render
-}
getBlockPositionAndSize : Block -> { x : Int, y : Int, size : Int }
getBlockPositionAndSize block =
    let
        posX =
            block.x * config.blockSize

        posY =
            block.y * config.blockSize

        renderedBlockSize =
            config.blockSize
    in
        { x = posX
        , y = posY
        , size = renderedBlockSize
        }


{-| render by svg sprite id
-}
renderBlockById : String -> Block -> Svg Msg
renderBlockById svgId block =
    let
        blockPosition =
            getBlockPositionAndSize block
    in
        node "use"
            [ xlinkHref (config.svgSpritePath ++ svgId)
            , x (toString blockPosition.x)
            , y (toString blockPosition.y)
            , width (toString blockPosition.size)
            , height (toString blockPosition.size)
            ]
            []


{-| deprecated
render rectangle with color
-}
renderBlockByColor : String -> Block -> Svg Msg
renderBlockByColor color block =
    let
        blockPosition =
            getBlockPositionAndSize block

        blockRadius =
            toString (round (toFloat config.blockSize / 8))
    in
        rect
            [ x (toString blockPosition.x)
            , y (toString blockPosition.y)
            , width (toString blockPosition.size)
            , height (toString blockPosition.size)
            , fill color
            , rx blockRadius
            , ry blockRadius
            ]
            []


{-| render ribbon with success message
-}
getWinRibbon : Model -> Html Msg
getWinRibbon model =
    if model.isWin then
        div []
            [ div [ class "overlay-body" ]
                [ div [ class "ribbon margin" ]
                    [ Html.text "Solved!" ]
                , button
                    [ class "button"
                    , onClick (Types.LoadLevel (model.currentLevel + 1))
                    ]
                    [ Html.text "Next" ]
                ]
            , div [ class "overlay" ] []
            ]
    else
        Html.text ""


getMovesCounter : Model -> Html Msg
getMovesCounter model =
    div [ class "counter" ]
        [ Html.text ("moves: " ++ (toString model.movesCount)) ]
