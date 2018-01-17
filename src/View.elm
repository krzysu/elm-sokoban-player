module View exposing (view)

import Html exposing (Html, text, div, button, h1, textarea)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class)
import Svg exposing (Svg, svg, node)
import Svg.Attributes
import Array exposing (Array)
import Level exposing (getViewLevelFromEncodedLevel)
import Types exposing (Model, Msg(..), Block, IViewLevel, Level, Page(..))


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
    case model.currentPage of
        GamePage ->
            renderGamePage model

        LevelSelectPage ->
            renderLevelSelectPage model


renderGamePage : Model -> Html Msg
renderGamePage model =
    div [ class "wrapper" ]
        [ h1 [ class "headline" ] [ Html.text "Sokoban Player" ]
        , renderLevel config.blockSize "game-arena" model
        , getMovesCounter model
        , getUndoButton model
        , getResetInfo
        , getSelectLevelButton
        , getWinOverlay model
        ]


renderLevel : Int -> String -> IViewLevel a -> Html Msg
renderLevel blockSize className levelToRender =
    let
        renderBlockById =
            renderBlockBySizeAndId blockSize
    in
        svg
            [ Svg.Attributes.width (toString (Tuple.first levelToRender.gameSize * blockSize))
            , Svg.Attributes.height (toString (Tuple.second levelToRender.gameSize * blockSize))
            , Svg.Attributes.class className
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
            [ Svg.Attributes.xlinkHref (config.svgSpritePath ++ svgId)
            , Svg.Attributes.x (toString blockPosition.x)
            , Svg.Attributes.y (toString blockPosition.y)
            , Svg.Attributes.width (toString blockSize)
            , Svg.Attributes.height (toString blockSize)
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
        , onClick Undo
        , Html.Attributes.disabled (List.isEmpty model.history)
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
                    , onClick LoadNextLevel
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
        , onClick (ShowLevelSelectPage)
        ]
        [ Html.text "Select level" ]


renderLevelSelectPage : Model -> Html Msg
renderLevelSelectPage model =
    div []
        [ h1 [ class "headline" ] [ Html.text "Create your playlist" ]
        , div [ class "level-preview-list" ]
            (model.levels
                |> Array.map (\encodedLevel -> ( encodedLevel, getViewLevelFromEncodedLevel encodedLevel ))
                |> Array.indexedMap renderLevelPreviewItem
                |> Array.toList
            )
        , div [ class "centered margin" ]
            [ textarea
                [ class "input level-input"
                , onInput ChangeLevelFromUserInput
                , Html.Attributes.placeholder "insert your sokoban level"
                , Html.Attributes.value model.stringLevelFromUserInput
                ]
                []
            ]
        , div [ class "centered button-group margin" ]
            [ button
                [ class "button button--small"
                , onClick AddLevelFromUserInput
                ]
                [ Html.text "Add level" ]
            ]
        ]


renderLevelPreviewItem : Int -> ( String, IViewLevel a ) -> Html Msg
renderLevelPreviewItem levelIndex ( levelId, viewLevel ) =
    div [ class "level-preview-item" ]
        [ div
            [ class "level-preview-item__level"
            , onClick (LoadLevel levelIndex)
            ]
            [ renderLevel config.previewBlockSize "" viewLevel ]
        , button
            [ class "button button--small level-preview-item__delete-button"
            , onClick (RemoveLevel levelId)
            ]
            [ Html.text "X" ]
        ]
