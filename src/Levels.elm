module Levels exposing (getInitialLevels, getLevel, addLevel)

import Array exposing (Array)
import Types exposing (Level)
import XmlLevel exposing (getLevelFromXml)
import StringLevel exposing (getLevelFromString)


getLevel : Int -> List Level -> Level
getLevel number levels =
    Array.get number (Array.fromList levels)
        |> Maybe.withDefault (Level 0 0 [])


addLevel : List Level -> Level -> List Level
addLevel levels newLevel =
    newLevel :: levels


getInitialLevels : List Level
getInitialLevels =
    [ getLevelFromXml xmlLevel
    , getLevelFromString stringLevel1
    , getLevelFromString stringLevel2
    , getLevelFromString stringLevel3
    , getLevelFromString stringLevel4
    , getLevelFromString stringLevel5
    ]


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
