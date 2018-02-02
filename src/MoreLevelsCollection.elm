module MoreLevelsCollection exposing (getLevels)

import Array exposing (Array)
import Types exposing (LevelCollection)
import StringLevel exposing (getLevelFromString)


getLevels : LevelCollection
getLevels =
    let
        stringLevels =
            [ stringLevel1
            , stringLevel2
            , stringLevel3
            , stringLevel4
            , stringLevel5
            , stringLevel6
            , stringLevel7
            , stringLevel8
            , stringLevel9
            , stringLevel10
            , stringLevel11
            , stringLevel12
            , stringLevel13
            , stringLevel14
            , stringLevel15
            , stringLevel16
            , stringLevel17
            , stringLevel18
            , stringLevel19
            , stringLevel20
            , stringLevel21
            , stringLevel22
            , stringLevel23
            , stringLevel24
            , stringLevel25
            , stringLevel26
            , stringLevel27
            , stringLevel28
            , stringLevel29
            , stringLevel19
            , stringLevel30
            , stringLevel31
            , stringLevel32
            , stringLevel33
            , stringLevel34
            , stringLevel35
            , stringLevel36
            , stringLevel37
            , stringLevel38
            , stringLevel39
            , stringLevel40
            ]
    in
        stringLevels
            -- TODO pagination
            |> List.take 20
            |> List.filterMap getLevelFromString
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


stringLevel6 : String
stringLevel6 =
    """
######  ###
#..  # ##@##
#..  ###   #
#..     $$ #
#..  # # $ #
#..### # $ #
#### $ #$  #
   #  $# $ #
   # $  $  #
   #  ##   #
   #########
"""


stringLevel7 : String
stringLevel7 =
    """
       #####
 #######   ##
## # @## $$ #
#    $      #
#  $  ###   #
### #####$###
# $  ### ..#
# $ $ $ ...#
#    ###...#
# $$ # #...#
#  ### #####
####
"""


stringLevel8 : String
stringLevel8 =
    """
  ####
  #  ###########
  #    $   $ $ #
  # $# $ #  $  #
  #  $ $  #    #
### $# #  #### #
#@#$ $ $  ##   #
#    $ #$#   # #
#   $    $ $ $ #
#####  #########
  #      #
  #      #
  #......#
  #......#
  #......#
  ########
"""


stringLevel9 : String
stringLevel9 =
    """
          #######
          #  ...#
      #####  ...#
      #      . .#
      #  ##  ...#
      ## ##  ...#
     ### ########
     # $$$ ##
 #####  $ $ #####
##   #$ $   #   #
#@ $  $    $  $ #
###### $$ $ #####
     #      #
     ########
"""


stringLevel10 : String
stringLevel10 =
    """
 ###  #############
##@####       #   #
# $$   $$  $ $ ...#
#  $$$#    $  #...#
# $   # $$ $$ #...#
###   #  $    #...#
#     # $ $ $ #...#
#    ###### ###...#
## #  #  $ $  #...#
#  ## # $$ $ $##..#
# ..# #  $      #.#
# ..# # $$$ $$$ #.#
##### #       # #.#
    # ######### #.#
    #           #.#
    ###############
"""


stringLevel11 : String
stringLevel11 =
    """
          ####
     #### #  #
   ### @###$ #
  ##      $  #
 ##  $ $$## ##
 #  #$##     #
 # # $ $$ # ###
 #   $ #  # $ #####
####    #  $$ #   #
#### ## $         #
#.    ###  ########
#.. ..# ####
#...#.#
#.....#
#######
"""


stringLevel12 : String
stringLevel12 =
    """
################
#              #
# # ######     #
# #  $ $ $ $#  #
# #   $@$   ## ##
# #  $ $ $###...#
# #   $ $  ##...#
# ###$$$ $ ##...#
#     # ## ##...#
#####   ## ##...#
    #####     ###
        #     #
        #######
"""


stringLevel13 : String
stringLevel13 =
    """
   #########
  ##   ##  ######
###     #  #    ###
#  $ #$ #  #  ... #
# # $#@$## # #.#. #
#  # #$  #    . . #
# $    $ # # #.#. #
#   ##  ##$ $ . . #
# $ #   #  #$#.#. #
## $  $   $  $... #
 #$ ######    ##  #
 #  #    ##########
 ####
"""


stringLevel14 : String
stringLevel14 =
    """
       #######
 #######     #
 #     # $@$ #
 #$$ #   #########
 # ###......##   #
 #   $......## # #
 # ###......     #
##   #### ### #$##
#  #$   #  $  # #
#  $ $$$  # $## #
#   $ $ ###$$ # #
#####     $   # #
    ### ###   # #
      #     #   #
      ########  #
             ####
"""


stringLevel15 : String
stringLevel15 =
    """
   ########
   #   #  #
   #  $   #
 ### #$   ####
 #  $  ##$   #
 #  # @ $ # $#
 #  #      $ ####
 ## ####$##     #
 # $#.....# #   #
 #  $..**. $# ###
##  #.....#   #
#   ### #######
# $$  #  #
#  #     #
######   #
     #####
"""


stringLevel16 : String
stringLevel16 =
    """
#####
#   ##
#    #  ####
# $  ####  #
#  $$ $   $#
###@ #$    ##
 #  ##  $ $ ##
 # $  ## ## .#
 #  #$##$  #.#
 ###   $..##.#
  #    #.*...#
  # $$ #.....#
  #  #########
  #  #
  ####
"""


stringLevel17 : String
stringLevel17 =
    """
   ##########
   #..  #   #
   #..      #
   #..  #  ####
  #######  #  ##
  #            #
  #  #  ##  #  #
#### ##  #### ##
#  $  ##### #  #
# # $  $  # $  #
# @$  $   #   ##
#### ## #######
   #    #
   ######
"""


stringLevel18 : String
stringLevel18 =
    """
     ###########
     #  .  #   #
     # #.    @ #
 ##### ##..# ####
##  # ..###     ###
# $ #...   $ #  $ #
#    .. ##  ## ## #
####$##$# $ #   # #
  ## #    #$ $$ # #
  #  $ # #  # $## #
  #               #
  #  ###########  #
  ####         ####
"""


stringLevel19 : String
stringLevel19 =
    """
  ######
  #   @####
##### $   #
#   ##    ####
# $ #  ##    #
# $ #  ##### #
## $  $    # #
## $ $ ### # #
## #  $  # # #
## # #$#   # #
## ###   # # ######
#  $  #### # #....#
#    $    $   ..#.#
####$  $# $   ....#
#       #  ## ....#
###################
"""


stringLevel20 : String
stringLevel20 =
    """
    ##########
#####        ####
#     #   $  #@ #
# #######$####  ###
# #    ## #  #$ ..#
# # $     #  #  #.#
# # $  #     #$ ..#
# #  ### ##     #.#
# ###  #  #  #$ ..#
# #    #  ####  #.#
# #$   $  $  #$ ..#
#    $ # $ $ #  #.#
#### $###    #$ ..#
   #    $$ ###....#
   #      ## ######
   ########
"""


stringLevel21 : String
stringLevel21 =
    """
#########
#       #
#       ####
## #### #  #
## #@##    #
# $$$ $  $$#
#  # ## $  #
#  # ##  $ ####
####  $$$ $#  #
 #   ##   ....#
 # #   # #.. .#
 #   # # ##...#
 ##### $  #...#
     ##   #####
      #####
"""


stringLevel22 : String
stringLevel22 =
    """
######     ####
#    #######  #####
#   $#  #  $  #   #
#  $  $  $ # $ $  #
##$ $   # @# $    #
#  $ ########### ##
# #   #.......# $#
# ##  # ......#  #
# #   $........$ #
# # $ #.... ..#  #
#  $ $####$#### $#
# $   ### $   $  ##
# $     $ $  $    #
## ###### $ ##### #
#         #       #
###################
"""


stringLevel23 : String
stringLevel23 =
    """
    #######
    #  #  ####
##### $#$ #  ##
#.. #  #  #   #
#.. # $#$ #  $####
#.  #     #$  #  #
#..   $#  # $    #
#..@#  #$ #$  #  #
#.. # $#     $#  #
#.. #  #$$#$  #  ##
#.. # $#  #  $#$  #
#.. #  #  #   #   #
##. ####  #####   #
 ####  ####   #####
"""


stringLevel24 : String
stringLevel24 =
    """
###############
#..........  .####
#..........$$.#  #
###########$ #   ##
#      $  $     $ #
## ####   #  $ #  #
#      #   ##  # ##
#  $#  # ##  ### ##
# $ #$###    ### ##
###  $ #  #  ### ##
###    $ ## #  # ##
 # $  #  $  $ $   #
 #  $  $#$$$  #   #
 #  #  $      #####
 # @##  #  #  #
 ##############
"""


stringLevel25 : String
stringLevel25 =
    """
####
#  ##############
#  #   ..#......#
#  # # ##### ...#
##$#    ........#
#   ##$######  ####
# $ #     ######@ #
##$ # $   ######  #
#  $ #$$$##       #
#      #    #$#$###
# #### #$$$$$    #
# #    $     #   #
# #   ##        ###
# ######$###### $ #
#        #    #   #
##########    #####
"""


stringLevel26 : String
stringLevel26 =
    """
 #######
 #  #  #####
##  #  #...###
#  $#  #...  #
# $ #$$ ...  #
#  $#  #... .#
#   # $########
##$       $ $ #
##  #  $$ #   #
 ######  ##$$@#
      #      ##
      ########
"""


stringLevel27 : String
stringLevel27 =
    """
 #################
 #...   #    #   ##
##.....  $## # #$ #
#......#  $  #    #
#......#  #  # #  #
######### $  $ $  #
  #     #$##$ ##$##
 ##   $    # $    #
 #  ## ### #  ##$ #
 # $ $$     $  $  #
 # $    $##$ ######
 #######  @ ##
       ######
"""


stringLevel28 : String
stringLevel28 =
    """
         #####
     #####   #
    ## $  $  ####
##### $  $ $ ##.#
#       $$  ##..#
#  ###### ###.. #
## #  #    #... #
# $   #    #... #
#@ #$ ## ####...#
####  $ $$  ##..#
   ##  $ $  $...#
    # $$  $ #  .#
    #   $ $  ####
    ######   #
         #####
"""


stringLevel29 : String
stringLevel29 =
    """
#####
#   ##
# $  #########
## # #       ######
## #   $#$#@  #   #
#  #      $ #   $ #
#  ### ######### ##
#  ## ..*..... # ##
## ## *.*..*.* # ##
# $########## ##$ #
#  $   $  $    $  #
#  #   #   #   #  #
###################
"""


stringLevel30 : String
stringLevel30 =
    """
       ###########
       #   #     #
#####  #     $ $ #
#   ##### $## # ##
# $ ##   # ## $  #
# $  @$$ # ##$$$ #
## ###   # ##    #
## #   ### #####$#
## #     $  #....#
#  ### ## $ #....##
# $   $ #   #..$. #
#  ## $ #  ##.... #
#####   ######...##
    #####    #####
"""


stringLevel31 : String
stringLevel31 =
    """
  ####
  #  #########
 ##  ##  #   #
 #  $# $@$   ####
 #$  $  # $ $#  ##
##  $## #$ $     #
#  #  # #   $$$  #
# $    $  $## ####
# $ $ #$#  #  #
##  ###  ###$ #
 #  #....     #
 ####......####
   #....####
   #...##
   #...#
   #####
"""


stringLevel32 : String
stringLevel32 =
    """
      ####
  #####  #
 ##     $#
## $  ## ###
#@$ $ # $  #
#### ##   $#
 #....#$ $ #
 #....#   $#
 #....  $$ ##
 #... # $   #
 ######$ $  #
      #   ###
      #$ ###
      #  #
      ####
"""


stringLevel33 : String
stringLevel33 =
    """
 ###########
 #     ##  #
 #   $   $ #
#### ## $$ #
#   $ #    #
# $$$ # ####
#   # # $ ##
#  #  #  $ #
# $# $#    #
#   ..# ####
####.. $ #@#
#.....# $# #
##....#  $ #
 ##..##    #
  ##########
"""


stringLevel34 : String
stringLevel34 =
    """
 #########
 #....   ##
 #.#.#  $ ##
##....# # @##
# ....#  #  ##
#     #$ ##$ #
## ###  $    #
 #$  $ $ $#  #
 # #  $ $ ## #
 #  ###  ##  #
 #    ## ## ##
 #  $ #  $  #
 ###$ $   ###
   #  #####
   ####
"""


stringLevel35 : String
stringLevel35 =
    """
############ ######
#   #    # ###....#
#   $$#   @  .....#
#   # ###   # ....#
## ## ###  #  ....#
 # $ $     # # ####
 #  $ $##  #      #
#### #  #### # ## #
#  # #$   ## #    #
# $  $  # ## #   ##
# # $ $    # #   #
#  $ ## ## # #####
# $$     $$  #
## ## ### $  #
 #    # #    #
 ###### ######
"""


stringLevel36 : String
stringLevel36 =
    """
            #####
#####  ######   #
#   ####  $ $ $ #
# $   ## ## ##  ##
#   $ $     $  $ #
### $  ## ##     ##
  # ##### #####$$ #
 ##$##### @##     #
 # $  ###$### $  ##
 # $  #   ###  ###
 # $$ $ #   $$ #
 #     #   ##  #
 #######.. .###
    #.........#
    #.........#
    ###########
"""


stringLevel37 : String
stringLevel37 =
    """
###########
#......   #########
#......   #  ##   #
#..### $    $     #
#... $ $ #   ##   #
#...#$#####    #  #
###    #   #$  #$ #
  #  $$ $ $  $##  #
  #  $   #$#$ ##$ #
  ### ## #    ##  #
   #  $ $ ## ######
   #    $  $  #
   ##   # #   #
    #####@#####
        ###
"""


stringLevel38 : String
stringLevel38 =
    """
      ####
####### @#
#     $  #
#   $## $#
##$#...# #
 # $...  #
 # #. .# ##
 #   # #$ #
 #$  $    #
 #  #######
 ####
"""


stringLevel39 : String
stringLevel39 =
    """
             ######
 #############....#
##   ##     ##....#
#  $$##  $ @##....#
#      $$ $#  ....#
#  $ ## $$ # # ...#
#  $ ## $  #  ....#
## ##### ### ##.###
##   $  $ ##   .  #
# $###  # ##### ###
#   $   #       #
#  $ #$ $ $###  #
# $$$# $   # ####
#    #  $$ #
######   ###
     #####
"""


stringLevel40 : String
stringLevel40 =
    """
    ############
    #          ##
    #  # #$$ $  #
    #$ #$#  ## @#
   ## ## # $ # ##
   #   $ #$  # #
   #   # $   # #
   ## $ $   ## #
   #  #  ##  $ #
   #    ## $$# #
######$$   #   #
#....#  ########
#.#... ##
#....   #
#....   #
#########
"""
