module Levels exposing (getLevel)

import Array
import Types exposing (Level)
import XmlLevel exposing (getXmlLevel)
import StringLevel exposing (getStringLevel)


getLevel : Int -> Level
getLevel number =
    Array.get number levels
        |> Maybe.withDefault (Level 0 0 [])


{-| example level, not in use
-}
level : Level
level =
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


levels : Array.Array Level
levels =
    Array.fromList
        [ getStringLevel stringLevel1
        , getStringLevel stringLevel2
        , getStringLevel stringLevel3
        , getStringLevel stringLevel4
        , getStringLevel stringLevel5
        , getXmlLevel xmlLevel
        ]
