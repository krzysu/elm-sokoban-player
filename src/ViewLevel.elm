module ViewLevel exposing (getViewLevelFromLevel, getLevelFromViewLevel)

import Types exposing (Block, Level, ViewLevel)


getLevelFromViewLevel : ViewLevel -> Level
getLevelFromViewLevel viewLevel =
    let
        width =
            Tuple.first viewLevel.gameSize

        height =
            Tuple.second viewLevel.gameSize
    in
        Level width height (getLevelMap viewLevel) ""


getLevelMap : ViewLevel -> List (List Char)
getLevelMap viewLevel =
    -- create array of length equal to width of level
    -- multiply them by height
    -- Array.set
    -- or
    -- merge all blocks but add type
    -- sort by coordinates
    -- then go through them and generate array
    -- for duplicated Block coordinates, decide on priority
    [ [] ]


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
