module Model exposing (initModelWithLevelNumber)

import Types exposing (Model, Block, Level)
import Levels exposing (getLevel)


initModelWithLevelNumber : Int -> Model
initModelWithLevelNumber levelNumber =
    let
        level =
            getLevel levelNumber
    in
        { player = Maybe.withDefault (Block 0 0) <| List.head (levelToBlocks level [ '@', '+' ])
        , walls = levelToBlocks level [ '#' ]
        , boxes = levelToBlocks level [ '$', '*' ]
        , dots = levelToBlocks level [ '.', '+', '*' ]
        , isWin = False
        , gameSize = ( level.width, level.height )
        , currentLevel = levelNumber
        , movesCount = 0
        , history = []
        }


levelToBlocks : Level -> List Char -> List Block
levelToBlocks level entityCharList =
    let
        maybeBlocks =
            List.indexedMap
                (\y row ->
                    List.indexedMap
                        (\x char ->
                            if (List.member char entityCharList) then
                                Just (Block x y)
                            else
                                Nothing
                        )
                        row
                )
                level.map
    in
        maybeBlocks
            |> List.concat
            |> List.filterMap identity
