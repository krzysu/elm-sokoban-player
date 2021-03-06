module LevelCollection
    exposing
        ( getInitialLevels
        , getLevel
        , appendLevel
        , prependLevel
        , removeLevel
        , isDuplicate
        , getIndexOf
        )

import Array exposing (Array)
import Dict
import Types exposing (EncodedLevel, LevelCollection, Level)
import StringLevel exposing (getLevelFromString)


getIndexOf : EncodedLevel -> LevelCollection -> Int
getIndexOf levelId levels =
    levels
        |> Array.toIndexedList
        |> List.map (\( index, levelId ) -> ( levelId, index ))
        |> Dict.fromList
        |> Dict.get levelId
        |> Maybe.withDefault -1


getLevel : Int -> LevelCollection -> EncodedLevel
getLevel levelIndex levels =
    levels
        |> Array.get levelIndex
        |> Maybe.withDefault ""


isDuplicate : EncodedLevel -> LevelCollection -> Bool
isDuplicate levelId levels =
    levels
        |> Array.filter (\level -> level == levelId)
        |> Array.isEmpty
        |> not


appendLevel : EncodedLevel -> LevelCollection -> LevelCollection
appendLevel levelId levels =
    if (isDuplicate levelId levels) then
        levels
    else
        Array.push levelId levels


prependLevel : EncodedLevel -> LevelCollection -> LevelCollection
prependLevel levelId levels =
    if (isDuplicate levelId levels) then
        levels
    else
        Array.toList levels
            |> (::) levelId
            |> Array.fromList


removeLevel : EncodedLevel -> LevelCollection -> LevelCollection
removeLevel levelId levels =
    levels
        |> Array.filter (\level -> not (level == levelId))


getInitialLevels : LevelCollection
getInitialLevels =
    let
        stringLevels =
            [ stringLevel0
            , stringLevel1
            , stringLevel2
            , stringLevel3
            ]
    in
        stringLevels
            |> List.filterMap getLevelFromString
            |> List.map .id
            |> Array.fromList


stringLevel0 : String
stringLevel0 =
    """
#############
#.          #
#     $     #
#           #
#     @     #
#           #
#############
"""


stringLevel1 : String
stringLevel1 =
    """
    #####
    #   #
    #$  #
  ###  $##
  #  $ $ #
### # ## #   ######
#   # ## #####  ..#
# $  $          ..#
##### ### #@##  ..#
    #     #########
    #######
"""


stringLevel2 : String
stringLevel2 =
    """
############
#..  #     ###
#..  # $  $  #
#..  #$####  #
#..    @ ##  #
#..  # #  $ ##
###### ##$ $ #
  # $  $ $ $ #
  #    #     #
  ############
"""


stringLevel3 : String
stringLevel3 =
    """
        ########
        #     @#
        # $#$ ##
        # $  $#
        ##$ $ #
######### $ # ###
#....  ## $  $  #
##...    $  $   #
#....  ##########
########
"""


xmlLevel : String
xmlLevel =
    """
<Level Id="soko42" Width="7" Height="9">
  <L> ######</L>
  <L> #    #</L>
  <L>## $  #</L>
  <L>#  ##$#</L>
  <L># $.#.#</L>
  <L># $...#</L>
  <L># $####</L>
  <L>#@ #</L>
  <L>####</L>
</Level>
"""
