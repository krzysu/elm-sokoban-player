module LevelView exposing (renderLevel, renderLevelWithDirection)

import Html exposing (Html)
import Svg exposing (Svg, svg, node)
import Svg.Attributes
import Set exposing (Set)
import Types exposing (Model, Msg(..), Block, IViewLevel, Level, LevelData, Page(..), MoveDirection(..))


renderLevel : Int -> IViewLevel a -> Html Msg
renderLevel =
    renderLevelWithDirection Down


renderLevelWithDirection : MoveDirection -> Int -> IViewLevel a -> Html Msg
renderLevelWithDirection direction blockSize viewLevel =
    let
        blockById =
            blockBySizeAndId blockSize
    in
        svg
            [ Svg.Attributes.width (toString (Tuple.first viewLevel.gameSize * blockSize))
            , Svg.Attributes.height (toString (Tuple.second viewLevel.gameSize * blockSize))
            ]
            (List.concat
                [ List.map (blockById "#wallBrown") viewLevel.walls
                , List.map (blockById "#dotGreen") viewLevel.dots
                , boxes viewLevel.dots viewLevel.boxes blockById
                , [ player blockById direction viewLevel.player ]
                ]
            )


{-| render by svg sprite id
-}
blockBySizeAndId : Int -> String -> Block -> Svg Msg
blockBySizeAndId blockSize svgId block =
    let
        blockPosition =
            { x = block.x * blockSize
            , y = block.y * blockSize
            }
    in
        node "use"
            [ Svg.Attributes.xlinkHref svgId
            , Svg.Attributes.x (toString blockPosition.x)
            , Svg.Attributes.y (toString blockPosition.y)
            , Svg.Attributes.width (toString blockSize)
            , Svg.Attributes.height (toString blockSize)
            ]
            []


boxes : List Block -> List Block -> (String -> Block -> Svg Msg) -> List (Svg Msg)
boxes dotList boxList blockById =
    let
        boxSet =
            blocksToSet boxList

        dotSet =
            blocksToSet dotList

        boxesOverDots =
            Set.intersect boxSet dotSet
                |> setToBlocks

        boxesNotOverDots =
            Set.diff boxSet dotSet
                |> setToBlocks
    in
        List.concat
            [ List.map (blockById "#boxGreenAlt") boxesOverDots
            , List.map (blockById "#boxGreen") boxesNotOverDots
            ]


blocksToSet : List Block -> Set ( Int, Int )
blocksToSet blocks =
    blocks
        |> List.map (\{ x, y } -> ( x, y ))
        |> Set.fromList


setToBlocks : Set ( Int, Int ) -> List Block
setToBlocks set =
    set
        |> Set.toList
        |> List.map (\( x, y ) -> Block x y)


player : (String -> Block -> Svg Msg) -> MoveDirection -> Block -> Svg Msg
player blockById direction block =
    case direction of
        Left ->
            blockById "#playerLeft" block

        Right ->
            blockById "#playerRight" block

        Up ->
            blockById "#playerBack" block

        Down ->
            blockById "#playerFront" block
