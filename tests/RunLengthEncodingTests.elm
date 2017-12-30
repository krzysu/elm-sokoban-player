module RunLengthEncodingTests exposing (..)

import Test exposing (..)
import Expect
import RunLengthEncoding exposing (encode, decode)


longLevelFormat =
    """#######
#.@ # #
#$* $ #
#   $ #
# ..  #
#  *  #
#######
"""


shortLevelFormat =
    "7#|#.@_#_#|#$*_$_#|#3_$_#|#_2.2_#|#2_*2_#|7#|"


all : Test
all =
    describe "RunLengthEncoding"
        [ describe "decode"
            [ test "case 1" <|
                \_ ->
                    let
                        shortFormat =
                            "4#"

                        longFormat =
                            "####"
                    in
                        Expect.equal (decode shortFormat) longFormat
            , test "case 2" <|
                \_ ->
                    let
                        shortFormat =
                            "#.@_#_#"

                        longFormat =
                            "#.@ # #"
                    in
                        Expect.equal (decode shortFormat) longFormat
            , test "case 3" <|
                \_ ->
                    let
                        shortFormat =
                            "#3_$_#"

                        longFormat =
                            "#   $ #"
                    in
                        Expect.equal (decode shortFormat) longFormat
            ]
        , describe "encode"
            [ test "case 1" <|
                \_ ->
                    let
                        longFormat =
                            "####"

                        shortFormat =
                            "4#"
                    in
                        Expect.equal (encode longFormat) shortFormat
            , test "case 2" <|
                \_ ->
                    let
                        longFormat =
                            "####$$"

                        shortFormat =
                            "4#2$"
                    in
                        Expect.equal (encode longFormat) shortFormat
            ]
        , describe "sokoban levels"
            [ test "encode, case 1" <|
                \_ ->
                    Expect.equal (encode longLevelFormat) shortLevelFormat
            , test "decode, case 1" <|
                \_ ->
                    Expect.equal (decode shortLevelFormat) longLevelFormat
            , test "decode and encode" <|
                \_ ->
                    let
                        longFormat =
                            decode shortLevelFormat
                    in
                        Expect.equal (encode longFormat) shortLevelFormat
            , test "encode and decode" <|
                \_ ->
                    let
                        shortFormat =
                            encode longLevelFormat
                    in
                        Expect.equal (decode shortFormat) longLevelFormat
            ]
        ]
