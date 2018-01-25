module Sub exposing (subscriptions)

import Keyboard
import Window
import Types exposing (Model, Msg(..), Page(..), MoveDirection(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs (keyPressed model)
        , Window.resizes WindowSizeUpdated
        ]


keyPressed : Model -> Keyboard.KeyCode -> Msg
keyPressed model code =
    case model.currentPage of
        GamePage ->
            if model.isWin then
                case code of
                    13 ->
                        -- Enter
                        LoadNextLevel

                    _ ->
                        NoOp
            else
                case code of
                    37 ->
                        -- LeftKey
                        Move Left

                    38 ->
                        -- UpKey
                        Move Up

                    39 ->
                        -- RightKey
                        Move Right

                    40 ->
                        -- DownKey
                        Move Down

                    27 ->
                        -- Esc
                        RestartLevel

                    85 ->
                        -- u
                        Undo

                    _ ->
                        NoOp

        LevelSelectPage ->
            NoOp
