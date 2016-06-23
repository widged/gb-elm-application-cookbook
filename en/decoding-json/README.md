**elm 0.17**, **copied from [elm-recipes-master](https://github.com/alexspurling/elm-recipes)**

## Decoding JSON

**JavaScript Ojbect Notation (JSON)** is a defined in its official specification (http://json.org/) as:

> a lightweight data-interchange format. It is easy for humans to read and write. It is easy for machines to parse and generate. 

JSON is a text format that language agnostic and this makes it an ideal data-interchange language.

This tutorial covers:

* How to parse a simple Json document
* How to create an Elm Json Decoder
* How to chain Decoders
* How to handle parsing errors


### Getting ready

Elm provides the [Json.Decode](http://package.elm-lang.org/packages/elm-lang/core/4.0.1/Json-Decode) module as part of the core library. 

Here's a simple Json document. It contains field with values of different types.



### How to do it

```
{
  "name": "Jim",
  "age": 65,
  "height": 1.87,
  "address": {
    "line1": "123 Columbia Lane"
  },
  "children": ["Jane", "Jill"],
  "registered": true,
  "party": "Republican"
}
```

Let's build an Elm model to represent this structure:

```elm
type alias Voter =
  { name : String
  , age : Int
  , height : Float
  , address : Address
  , children : List String
  , registered : Bool
  , party : Party
  }

type Party = Republican | Democrat

type alias Address =
  { line1 : String
  }
```

#### Creating a Decoder

Before we even touch the input Json string above, we first need to create a `Decoder Voter`. `Decoder Voter`s are things that will convert Json data into a `Voter` or fail. You cannot create one from scratch though -- you build it up out of simple `Decoder`s provided by the standard library.  Fortunately, the `Json.Decoder` module exposes a `Decoder` for all the Json primitive types such as `string`, `int` and quite a few ways to combine them.

Let's look at our first `Decoder` function:

```elm
import Json.Decode exposing (Decoder, (:=), object7, int, string, float, bool, list)

voterDecoder : Decoder Voter
voterDecoder =
  object7 Voter
    ("name" := string)
    ("age" := int)
    ("height" := float)
    ("address" := addressDecoder)
    ("children" := (list string))
    ("registered" := bool)
    ("party" := partyDecoder)
```

There's quite a lot going on here, so let's break it down. First of all, we know we want to decode a Json object with 7 fields (name, age, height etc). The Decoder module provides a function `object7` which takes a constructor followed by 7 arguments. To this we are passing a constructor function for our `Voter` type followed by 7 other `Decoder`s one representing each of the fields in our object.

A Decoder that looks like this `("name" := string)` means, take the field "name" of the current Json object and decode it using the `string` Decoder. See the documentation for the [:= function](http://package.elm-lang.org/packages/elm-lang/core/4.0.1/Json-Decode#:=). Similarly, the other field decoders are created by referencing already existing primitive decoders (float, boolean, list), or by calling a custom `Decoder`.

Here is our `Address` `Decoder`:

```
addressDecoder : Decoder Address
addressDecoder =
  object1 Address ("line1" := string)
```

This is quite a straightforward `Decoder`, we expect the value to be decoded to be an object with a single field so we call `object1` with a constructor for our `Address` type, and another `Decoder` to decode the expected "line1" field.


#### Decoding a union type

Our next `Decoder` looks like this:

```elm
import Json.Decode exposing (andThen, succeed, fail)

partyDecoder : Decoder Party
partyDecoder =
  string `andThen` partyFromString

partyFromString : String -> Decoder Party
partyFromString party =
  case (toLower party) of
    "republican" ->
      succeed Republican
    "democrat" ->
      succeed Democrat
    _ ->
      fail (party ++ " is not a recognized party")
```

We expect the "party" field to be a string with one of two possible values. We use the same field extractor function from before (`:=`) but this time we chain it with another decoder that can convert the string into a valid value of type `Party`. Note how we use the `succeed` and `fail` functions which allow use to signal a successful or fails parse of the input value. This error will be propgated

Alternatively, if we did not want to handle an unknown party as an error, we could just define it as another valid option. All we then need to do, is pass a function to `Json.Decode.map` to tell it how to construct a Party from a String:

```elm
import Json.Decode exposing (map)

type Party = Republican | Democrat | Other

partyDecoder : Decoder Party
partyDecoder =
  map partyFromString ("party" := string)

partyFromString : String -> Party
partyFromString party =
  case (toLower party) of
    "republican" ->
      Republican
    "democrat" ->
      Democrat
    _ ->
      Other
```

#### Actually parsing the Json

Finally, let's actually parse some Json using our new shiny `Decoder`:

```elm
import Json.Decode exposing (decodeString)

viewVoter : Voter -> Html msg
viewVoter = ... --elided for brevity

viewParseResult : Result String Voter -> Html a
viewParseResult voterParseResult =
  case voterParseResult of
    Ok voter -> viewVoter voter
    Err error -> div [ ] [ text error ]

main : Html msg
main = viewParseResult (decodeString voterDecoder voterJson)
```

The function `decodeString` takes a Decoder, some Json as a String and returns a Result. A lot can go wrong when parsing Json, so it makes sense that Elm is returning us a value that can represent either success or failure. Any errors related to either badly formatted Json, or an unexpected Json document will be reported as an `Err error`. Let's try it out:

Parsing the Json shown at the start of the tutorial:

![](screen1.png)

Changing the "age" field from and Int to a String:

![](screen2.png)

Renaming one of the fields:

![](screen3.png)

Triggering our custom error handling:

![](screen4.png)

#### Further reading

This has given you an overview of parsing simple Json documents with Elm. You are probably thinking what a whole lot of effort to do something so simple and it's true it is certainly more work to write a Decoder than it might be in another language. However this is the trade off we make for the benefits of type safety.

I highly recommend continuing to read the [Json.Decode API docs](http://package.elm-lang.org/packages/elm-lang/core/4.0.1/Json-Decode) to get an idea for build more complex Json parsers.

[Decoding JSON Structures with Elm](https://robots.thoughtbot.com/decoding-json-structures-with-elm) is a tutorial that goes into more detail and also introduces the [elm-json-extra library](http://package.elm-lang.org/packages/circuithub/elm-json-extra/2.2.1/Json-Decode-Extra).

[Json-to-Elm](http://noredink.github.io/json-to-elm/) is a tool that automatically produces your Encoder/Decoder Elm code for you given a sample Json file. This is a good place to start but does not support union types.