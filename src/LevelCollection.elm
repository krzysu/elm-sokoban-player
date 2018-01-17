module LevelCollection exposing (getInitialLevels, getLevel, addLevel, removeLevel)

import Array exposing (Array)
import Types exposing (EncodedLevel, LevelCollection, Level)
import XmlLevel exposing (getLevelFromXml)
import StringLevel exposing (getLevelFromString)


getLevel : Int -> LevelCollection -> EncodedLevel
getLevel levelIndex levels =
    levels
        |> Array.get levelIndex
        |> Maybe.withDefault ""


addLevel : EncodedLevel -> LevelCollection -> LevelCollection
addLevel levelId levels =
    let
        alreadyExists =
            levels
                |> Array.filter (\level -> level == levelId)
                |> Array.isEmpty
                |> not
    in
        if alreadyExists then
            levels
        else
            Array.toList levels
                |> (::) levelId
                |> Array.fromList


removeLevel : String -> LevelCollection -> LevelCollection
removeLevel levelId levels =
    levels
        |> Array.filter (\level -> not (level == levelId))


getInitialLevels : LevelCollection
getInitialLevels =
    let
        stringLevels =
            [ stringLevel1
            , stringLevel2
            , stringLevel3
            , stringLevel4
            , stringLevel5
            ]

        levelFromXml =
            getLevelFromXml xmlLevel
    in
        stringLevels
            |> List.filterMap getLevelFromString
            |> (::) levelFromXml
            |> List.map .id
            |> Array.fromList


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


stringLevel4 : String
stringLevel4 =
    """
           ########
           #  ....#
############  ....#
#    #  $ $   ....#
# $$$#$  $ #  ....#
#  $     $ #  ....#
# $$ #$ $ $########
#  $ #     #
## #########
#    #    ##
#     $   ##
#  $$#$$  @#
#    #    ##
###########
"""


stringLevel5 : String
stringLevel5 =
    """
        #####
        #   #####
        # #$##  #
        #     $ #
######### ###   #
#....  ## $  $###
#....    $ $$ ##
#....  ##$  $ @#
#########  $  ##
        # $ $  #
        ### ## #
          #    #
          ######
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
