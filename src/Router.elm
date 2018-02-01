module Router exposing (match, go)

import Types exposing (Model, Msg, Page(..))
import Navigation exposing (Location)
import Model


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
            ( model, Navigation.newUrl "/" )

        PlaylistPage ->
            ( model, Navigation.newUrl "/playlist" )

        MoreLevelsPage ->
            ( model, Navigation.newUrl "/more-levels" )

        GamePage ->
            -- should not be used, load level instead
            ( model, Cmd.none )
