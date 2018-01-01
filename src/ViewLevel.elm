module ViewLevel exposing (getViewLevelFromLevel)

import Types exposing (Block, Level, ViewLevel)


getViewLevelFromLevel : Level -> ViewLevel
getViewLevelFromLevel level =
    { player = Maybe.withDefault (Block 0 0) <| List.head (levelToBlocks level [ '@', '+' ])
    , walls = levelToBlocks level [ '#' ]
    , boxes = levelToBlocks level [ '$', '*' ]
    , dots = levelToBlocks level [ '.', '+', '*' ]
    , gameSize = ( level.width, level.height )
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
