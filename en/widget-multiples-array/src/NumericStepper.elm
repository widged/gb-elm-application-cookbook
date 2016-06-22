module NumericStepper exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

type alias Model =
  { count : Int
  }

initialModel =
  { count = 0
  }

-- INTERACTIVITY

type Msg = Increment | Decrement

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      Increment ->
        { model | count = model.count + 1 } ! []
      Decrement ->
        { model | count = model.count - 1 } ! []

-- VIEW
view : Model -> Html Msg
view model =
    div []
      [ text (toString model.count ++ " ")
      , button [ onClick Increment ] [ text "+" ]
      , button [ onClick Decrement ] [ text "-" ]
      ]
