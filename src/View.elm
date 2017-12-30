module View exposing (view)

import Html exposing (Html, text, div, button)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Model exposing (getViewLevelFromLevel)
import Types exposing (Model, Msg, Block, IViewLevel, Level)
import Levels exposing (getAllLevels)


type alias Config =
    { blockSize : Int
    , previewBlockSize : Int
    , svgSpritePath : String
    }


config : Config
config =
    { blockSize = 60
    , previewBlockSize = 20
    , svgSpritePath = "sokoban.sprite.svg"
    }


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ renderLevel config.blockSize "game-arena" model
        , getMovesCounter model
        , getUndoButton model
        , getResetInfo
        , getSelectLevelButton
        , getWinOverlay model
        , getLevelSelectorOverlay getAllLevels model
        ]


renderLevel : Int -> String -> IViewLevel a -> Html Msg
renderLevel blockSize className levelToRender =
    let
        renderBlockById =
            renderBlockBySizeAndId blockSize
    in
        svg
            [ width (toString (Tuple.first levelToRender.gameSize * blockSize))
            , height (toString (Tuple.second levelToRender.gameSize * blockSize))
            , class className
            ]
            (List.concat
                [ List.map (renderBlockById "#wallBrown") levelToRender.walls
                , List.map (renderBlockById "#dotGreen") levelToRender.dots
                , List.map (renderBlockById "#boxGreen") levelToRender.boxes
                , [ renderBlockById "#playerFront" levelToRender.player ]
                ]
            )


{-| render by svg sprite id
-}
renderBlockBySizeAndId : Int -> String -> Block -> Svg Msg
renderBlockBySizeAndId blockSize svgId block =
    let
        blockPosition =
            { x = block.x * blockSize
            , y = block.y * blockSize
            }
    in
        node "use"
            [ xlinkHref (config.svgSpritePath ++ svgId)
            , x (toString blockPosition.x)
            , y (toString blockPosition.y)
            , width (toString blockSize)
            , height (toString blockSize)
            ]
            []


getMovesCounter : Model -> Html Msg
getMovesCounter model =
    div [ class "text margin" ]
        [ Html.text ("moves: " ++ (toString model.movesCount)) ]


getUndoButton : Model -> Html Msg
getUndoButton model =
    button
        [ class "button button--small margin"
        , onClick (Types.Undo)
        ]
        [ Html.text "Undo" ]


getResetInfo : Html Msg
getResetInfo =
    div [ class "text margin" ]
        [ Html.text "press ESC to restart" ]


{-| render overlay with success message
-}
getWinOverlay : Model -> Html Msg
getWinOverlay model =
    if model.isWin then
        div []
            [ div [ class "overlay-body" ]
                [ div [ class "ribbon" ]
                    [ Html.text "Solved!" ]
                , button
                    [ class "button margin"
                    , onClick (Types.LoadLevel (model.currentLevel + 1))
                    ]
                    [ Html.text "Next" ]
                ]
            , div [ class "overlay" ] []
            ]
    else
        Html.text ""


getSelectLevelButton : Html Msg
getSelectLevelButton =
    button
        [ class "button button--small margin"
        , onClick (Types.ShowLevelSelector)
        ]
        [ Html.text "Select level" ]


getLevelSelectorOverlay : List Level -> Model -> Html Msg
getLevelSelectorOverlay levels model =
    if model.showLevelSelector then
        div [ class "overlay" ]
            [ div [ class "level-preview-list" ]
                (levels
                    |> List.map getViewLevelFromLevel
                    |> List.indexedMap
                        (\index viewLevel ->
                            div
                                [ class "level-preview-item"
                                , onClick (Types.LoadLevel index)
                                ]
                                [ renderLevel config.previewBlockSize "" viewLevel
                                ]
                        )
                )
            ]
    else
        Html.text ""
