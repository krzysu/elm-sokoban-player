module Levels
    exposing
        ( getInitialLevels
        , getLevel
        , getNextLevel
        , addLevel
        , removeLevel
        )

import Dict exposing (Dict)
import Types exposing (Level)
import XmlLevel exposing (getLevelFromXml)
import StringLevel exposing (getLevelFromString)


getLevel : String -> Dict String Level -> Level
getLevel levelId levels =
    Dict.get levelId levels
        |> Maybe.withDefault (Level 0 0 [] "")


getNextLevel : String -> Dict String Level -> Level
getNextLevel currentLevelId levels =
    -- TODO
    Dict.get currentLevelId levels
        |> Maybe.withDefault (Level 0 0 [] "")


addLevel : Level -> Dict String Level -> Dict String Level
addLevel newLevel levels =
    Dict.insert newLevel.id newLevel levels


removeLevel : String -> Dict String Level -> Dict String Level
removeLevel levelId levels =
    Dict.remove levelId levels


getInitialLevels : Dict String Level
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
            |> List.map getLevelFromString
            |> List.map (\level -> ( level.id, level ))
            |> Dict.fromList
            |> Dict.insert levelFromXml.id levelFromXml


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


{-| example level to test dots, not in us
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
