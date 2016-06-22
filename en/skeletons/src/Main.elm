import Html exposing (Html, div, text, br)
import Html.App as App
--import Html.Attributes exposing (..)
--import Html.Events exposing (onClick)

-- Introducing the convention of using Store in the parent app. Provides context.

main : Program Never
main =
  App.program
    { init = initialStore ! [] -- equivalent of (initialStore, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none -- if none, declare it straightaway
    }

-- MODEL

type alias Store =
  { name : String
  , age: Int
  }

initialStore : Store
initialStore =
  { name = "Jane Doe"
  , age = 42
  }

-- INTERACTIVITY

type Msg = NoOp

update : Msg -> Store -> (Store, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      { model | age = 44 }  ! [] -- same as (model, Cmd.none) -- never executed as NoOp is never dispatched in our program

-- VIEW

view : Store -> Html Msg
view model =
  div []
    [ text "Store:"
    , br [] []
    , text (toString model)
    ]
