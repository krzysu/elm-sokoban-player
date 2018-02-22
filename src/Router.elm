port module Router exposing (match, go, portAnalytics)

import Navigation exposing (Location)
import Types exposing (Model, Msg, Page(..))
import Model


port portScrollToTop : Bool -> Cmd msg


port portAnalytics : String -> Cmd msg


match : Location -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
match location ( model, cmd ) =
    case location.pathname of
        "/" ->
            ( { model | currentPage = HomePage }
            , cmd
            )

        "/playlist" ->
            ( { model | currentPage = PlaylistPage }
            , cmd
            )

        "/more-levels" ->
            ( { model | currentPage = MoreLevelsPage }
            , cmd
            )

        _ ->
            Model.updateModelFromLocation location ( model, cmd )


go : Page -> Model -> ( Model, Cmd Msg )
go page model =
    case page of
        HomePage ->
            ( model
            , Cmd.batch
                [ Navigation.newUrl "/"
                , portScrollToTop True
                ]
            )

        PlaylistPage ->
            ( model
            , Cmd.batch
                [ Navigation.newUrl "/playlist"
                , portScrollToTop True
                ]
            )

        MoreLevelsPage ->
            ( model
            , Cmd.batch
                [ Navigation.newUrl "/more-levels"
                , portScrollToTop True
                ]
            )

        GamePage ->
            -- should not be used, load level instead
            ( model, Cmd.none )
