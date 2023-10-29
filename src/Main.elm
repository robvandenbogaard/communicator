module Main exposing (main)

import Browser
import Html
import Html.Attributes as Html
import Html.Events as Html
import Json.Decode as Decode
import Matrix
import Matrix.Event exposing (Event)
import Matrix.Room exposing (Room)


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type Model
    = Login { url : String, name : String, password : String }
    | LoggedIn { vault : Matrix.Vault, room : Maybe Room }


type Msg
    = LoginClicked
    | OnUrlInput String
    | OnNameInput String
    | OnPasswordInput String
    | MatrixUpdate Matrix.VaultUpdate
    | RoomClicked Room


type alias Message =
    { msgtype : String
    }


init () =
    ( Login { url = "https://matrix.org", name = "", password = "" }
    , Cmd.none
    )


update msg model =
    case model of
        Login { url, name, password } ->
            case msg of
                LoginClicked ->
                    let
                        vault =
                            Matrix.fromLoginCredentials
                                { baseUrl = url
                                , username = name
                                , password = password
                                }
                    in
                    ( LoggedIn
                        { vault = vault
                        , room = Nothing
                        }
                    , Matrix.sync vault MatrixUpdate
                    )

                OnUrlInput input ->
                    ( Login { url = input, name = name, password = password }, Cmd.none )

                OnNameInput input ->
                    ( Login { url = url, name = input, password = password }, Cmd.none )

                OnPasswordInput input ->
                    ( Login { url = url, name = name, password = input }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        LoggedIn state ->
            case msg of
                MatrixUpdate vaultUpdate ->
                    ( LoggedIn { state | vault = Matrix.updateWith vaultUpdate state.vault }, Cmd.none )

                RoomClicked room ->
                    ( LoggedIn { state | room = Just room }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


view model =
    { title = "Communicator"
    , body =
        case model of
            Login { url, name, password } ->
                loginView url name password

            LoggedIn { vault, room } ->
                mainView vault room
    }


mainView vault room =
    [ Html.table []
        [ Html.tr []
            [ Html.td [] [ Html.text "Dialogen" ]
            , Html.td []
                [ room
                    |> Maybe.andThen Matrix.Room.name
                    |> Maybe.withDefault "Start een gesprek"
                    |> Html.text
                ]
            ]
        , Html.tr []
            [ Html.td []
                [ Matrix.getRooms vault
                    |> List.map roomView
                    |> Html.ul []
                ]
            , Html.td []
                [ Html.dl []
                    (room
                        |> Maybe.map Matrix.Room.mostRecentEvents
                        |> Maybe.map (List.concatMap eventView)
                        |> Maybe.withDefault []
                    )
                ]
            ]
        ]
    ]


eventView event =
    [ Html.dt [] [ Html.text <| Matrix.Event.eventType event ++ " van " ++ Matrix.Event.sender event ]
    , Html.dd []
        [ Html.text <|
            case Matrix.Event.eventType event of
                "m.room.message" ->
                    Decode.decodeValue msgDecoder (Matrix.Event.content event)
                        |> Result.withDefault "couldn't decode"

                _ ->
                    Debug.toString (Matrix.Event.content event)
        ]
    ]


msgDecoder =
    Decode.field "msgtype" Decode.string
        |> Decode.andThen
            (\msgType ->
                case msgType of
                    "m.text" ->
                        Decode.field "body" Decode.string
                            |> Decode.map identity

                    _ ->
                        Decode.succeed msgType
            )


roomView room =
    Matrix.Room.name room
        |> Maybe.withDefault
            (Matrix.Room.description room
                |> Maybe.withDefault (Matrix.Room.roomId room)
            )
        |> Html.text
        |> List.singleton
        |> Html.a [ Html.onClick (RoomClicked room) ]
        |> List.singleton
        |> Html.li []


loginView url name password =
    [ Html.h1 [] [ Html.text "Onze eigen chat client" ]
    , Html.dl []
        [ Html.dt [] [ Html.label [] [ Html.text "Matrix server url (kan een eigen server zijn!)" ] ]
        , Html.dd [] [ Html.input [ Html.value url, Html.onInput OnUrlInput ] [] ]
        , Html.dt [] [ Html.label [] [ Html.text "Username (login-naam)" ] ]
        , Html.dd [] [ Html.input [ Html.value name, Html.onInput OnNameInput ] [] ]
        , Html.dt [] [ Html.label [] [ Html.text "Wachtwoord" ] ]
        , Html.dd [] [ Html.input [ Html.value password, Html.type_ "password", Html.onInput OnPasswordInput ] [] ]
        , Html.dt [] [ Html.button [ Html.onClick LoginClicked ] [ Html.text "Inloggen" ] ]
        , Html.dd [] []
        ]
    ]
