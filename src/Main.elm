module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Navigation
import Html as Html exposing (Html)
import Html.Attributes as Html
import Route exposing (Route)
import Url



-- MODEL


type alias Flags =
    { basePath : String }


type alias Model =
    { flags : Flags
    , navigation : Navigation
    }


type alias Navigation =
    { key : Navigation.Key
    , route : Route
    }


initialModel : Flags -> Url.Url -> Navigation.Key -> Model
initialModel ({ basePath } as flags) url key =
    { flags = flags
    , navigation =
        { key = key
        , route = Route.fromUrl basePath url
        }
    }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( initialModel flags url key, Cmd.none )



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChange Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ flags } as model) =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.navigation.key (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChange url ->
            let
                navigation =
                    model.navigation
            in
            ( { model
                | navigation =
                    { navigation
                        | route = Route.fromUrl flags.basePath url
                    }
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Document Msg
view ({ navigation } as model) =
    { title = textForRoute navigation.route ++ " - My Admin App"
    , body = [ bodyView model ]
    }


bodyView : Model -> Html Msg
bodyView model =
    Html.div
        []
        [ Html.nav
            [ Html.class "flex items-center justify-between flex-wrap bg-purple-500 p-6 mb-4" ]
            [ Html.div
                [ Html.class "container mx-auto w-full block flex-grow lg:flex lg:items-center lg:w-auto" ]
                [ Html.div
                    [ Html.class "text-sm lg:flex-grow text-purple-200" ]
                    [ Html.a
                        [ Html.href <| Route.toString Route.Home
                        , Html.classList
                            [ ( "block mt-4 lg:inline-block lg:mt-0 hover:text-white mr-4", True )
                            , ( "text-white", model.navigation.route == Route.Home )
                            ]
                        ]
                        [ Html.text "Home" ]
                    , Html.a
                        [ Html.href <| Route.toString Route.Projects
                        , Html.classList
                            [ ( "block mt-4 lg:inline-block lg:mt-0 hover:text-white mr-4", True )
                            , ( "text-white", model.navigation.route == Route.Projects )
                            ]
                        ]
                        [ Html.text "Projects" ]
                    , Html.a
                        [ Html.href <| Route.toString Route.Tasks
                        , Html.classList
                            [ ( "block mt-4 lg:inline-block lg:mt-0 hover:text-white mr-4", True )
                            , ( "text-white", model.navigation.route == Route.Tasks )
                            ]
                        ]
                        [ Html.text "Tasks" ]
                    , Html.a
                        [ Html.href <| Route.toString Route.Configuration
                        , Html.classList
                            [ ( "block mt-4 lg:inline-block lg:mt-0 hover:text-white mr-4", True )
                            , ( "text-white", model.navigation.route == Route.Configuration )
                            ]
                        ]
                        [ Html.text "Configuration" ]
                    ]
                ]
            ]
        , Html.div
            [ Html.class "container mx-auto" ]
            [ Html.h1
                [ Html.class "text-2xl" ]
                [ Html.text <| textForRoute model.navigation.route ]
            ]
        ]


textForRoute : Route -> String
textForRoute route =
    case route of
        Route.Home ->
            "Home page"

        Route.Projects ->
            "Projects page"

        Route.Tasks ->
            "Tasks page"

        Route.Configuration ->
            "Configuration page"

        Route.NotFound ->
            "Page not Found"



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- INIT


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChange
        }
