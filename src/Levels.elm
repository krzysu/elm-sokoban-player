module Levels exposing (getLevel, getAllLevels)

import Array
import Types exposing (Level)
import XmlLevel exposing (getXmlLevel)
import StringLevel exposing (getStringLevel)


getLevel : Int -> Level
getLevel number =
    Array.get number levels
        |> Maybe.withDefault (Level 0 0 [])


getAllLevels : List Level
getAllLevels =
    Array.toList levels


levels : Array.Array Level
levels =
    Array.fromList
        [ getXmlLevel xmlLevel
        , getStringLevel stringLevel1
        , getStringLevel stringLevel2
        , getStringLevel stringLevel3
        , getStringLevel stringLevel4
        , getStringLevel stringLevel5
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


stringLevel1 : String
stringLevel1 =
    """
    #####          |
    #   #          |
    #$  #          |
  ###  $##         |
  #  $ $ #         |
### # ## #   ######|
#   # ## #####  ..#|
# $  $          ..#|
##### ### #@##  ..#|
    #     #########|
    #######
"""


stringLevel2 : String
stringLevel2 =
    """
############       |
#..  #     ###     |
#..  # $  $  #     |
#..  #$####  #     |
#..    @ ##  #     |
#..  # #  $ ##     |
###### ##$ $ #     |
  # $  $ $ $ #     |
  #    #     #     |
  ############
"""


stringLevel3 : String
stringLevel3 =
    """
        ########   |
        #     @#   |
        # $#$ ##   |
        # $  $#    |
        ##$ $ #    |
######### $ # ###  |
#....  ## $  $  #  |
##...    $  $   #  |
#....  ##########  |
########
"""


stringLevel4 : String
stringLevel4 =
    """
           ########|
           #  ....#|
############  ....#|
#    #  $ $   ....#|
# $$$#$  $ #  ....#|
#  $     $ #  ....#|
# $$ #$ $ $########|
#  $ #     #       |
## #########       |
#    #    ##       |
#     $   ##       |
#  $$#$$  @#       |
#    #    ##       |
###########
"""


stringLevel5 : String
stringLevel5 =
    """
        #####      |
        #   #####  |
        # #$##  #  |
        #     $ #  |
######### ###   #  |
#....  ## $  $###  |
#....    $ $$ ##   |
#....  ##$  $ @#   |
#########  $  ##   |
        # $ $  #   |
        ### ## #   |
          #    #   |
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
