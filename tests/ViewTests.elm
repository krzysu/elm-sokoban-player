module ViewTests exposing (..)

import Test exposing (..)
import Expect
import View exposing (getGameBlockSize)


all : Test
all =
    describe "View"
        [ describe "getGameBlockSize"
            [ test "my laptop" <|
                \_ ->
                    Expect.equal
                        (getGameBlockSize { width = 1853, height = 962 } ( 14, 10 ))
                        60
            , test "ipad portrait" <|
                \_ ->
                    Expect.equal
                        (getGameBlockSize { width = 768, height = 1024 } ( 14, 10 ))
                        49
            , test "ipad landscape" <|
                \_ ->
                    Expect.equal
                        (getGameBlockSize { width = 1024, height = 768 } ( 14, 10 ))
                        60
            , test "some smartphone" <|
                \_ ->
                    Expect.equal
                        (getGameBlockSize { width = 360, height = 640 } ( 14, 10 ))
                        23
            ]
        ]
