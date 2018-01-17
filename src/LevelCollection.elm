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
    -- TODO check for duplicates
    Array.toList levels
        |> (::) levelId
        |> Array.fromList


removeLevel : String -> LevelCollection -> LevelCollection
removeLevel levelId levels =
    levels
        |> Array.filter (\level -> level == levelId)


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


{-| example level, not in use
-}
exampleLevel : Level
exampleLevel =
    { width = 5
    , height = 3
    , map =
        [ [ '#', '#', '#', '#', '#' ]
        , [ '#', '@', '$', '.', '#' ]
        , [ '#', '#', '#', '#', '#' ]
        ]
    , id = "5AHABDFAH5A"
    }


{-| example level to test dots, not in use
-}
exampleLevelTestDots : String
exampleLevelTestDots =
    """
 #####
# $+$.#
#    *#
 #####
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
