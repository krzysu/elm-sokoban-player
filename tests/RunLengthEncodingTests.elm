module RunLengthEncodingTests exposing (..)

import Test exposing (..)
import Expect
import RunLengthEncoding exposing (encode, decode)


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
                            "11$"

                        longFormat =
                            "$$$$$$$$$$$"
                    in
                        Expect.equal (decode shortFormat) longFormat
            , test "case 3" <|
                \_ ->
                    let
                        shortFormat =
                            "#$"

                        longFormat =
                            "#$"
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
            [ test "case 1" <|
                \_ ->
                    let
                        longFormat =
                            """
                            #######
                            #.@ # #
                            #$* $ #
                            #   $ #
                            # ..  #
                            #  *  #
                            #######
                            """

                        shortFormat =
                            "7#|#.@-#-#|#$*-$-#|#3-$-#|#-..--#|#--*--#|7#"
                    in
                        Expect.equal (encode longFormat) shortFormat
            ]
        ]
