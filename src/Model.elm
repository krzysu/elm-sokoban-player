module Model exposing (initModel)

import Types exposing (Model, Block, Level)


initModel : Level -> Model
initModel level =
    { player = Maybe.withDefault (Block 0 0) <| List.head (levelToBlocks level [ '@', '+' ])
    , walls = levelToBlocks level [ '#' ]
    , boxes = levelToBlocks level [ '$', '*' ]
    , dots = levelToBlocks level [ '.', '+', '*' ]
    , isWin = False
    , gameSize = ( level.width, level.height )
    , currentLevel = 0
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
