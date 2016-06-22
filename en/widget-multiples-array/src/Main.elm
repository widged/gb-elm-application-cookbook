import Html exposing (Html, div, text, br)
import Html.App as App
--import Html.Attributes exposing (..)
--import Html.Events exposing (onClick)
-- Introducing the convention of using Store in the parent app. Provides context.
import Array exposing (Array)
import NumericStepper
import Debug

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
  { steppers : Array NumericStepper.Model
  }

initialStore : Store
initialStore =
  { steppers = Array.fromList [NumericStepper.initialModel, NumericStepper.initialModel, NumericStepper.initialModel]
  }

-- INTERACTIVITY

type Msg = StepperMsg Int NumericStepper.Msg

fromJust : Maybe a -> a
fromJust x = case x of
    Just y -> y
    Nothing -> Debug.crash "error: fromJust Nothing"

update : Msg -> Store -> (Store, Cmd Msg)
update msg model =
  case msg of
    StepperMsg idx wgMsg ->
      let
        steppers = fromJust (Array.get idx model.steppers)
        ( newModel, cmd ) = NumericStepper.update wgMsg steppers
        newWidgets = Array.set idx newModel model.steppers
        z = Debug.log "idx" idx
      in
        ( { model | steppers = newWidgets }, Cmd.map (StepperMsg idx) cmd )

-- VIEW

view : Store -> Html Msg
view model =
  let
    stepperView (idx, v) = App.map (StepperMsg idx) (NumericStepper.view v)
    steppers = List.map stepperView (Array.toIndexedList model.steppers)
    log = Debug.log "steppers" steppers
  in
  div []
    [ text "Store:"
    , br [] []
    , text (toString model)
    , div [] steppers
    ]
