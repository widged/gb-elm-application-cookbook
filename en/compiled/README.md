elm make --h

elm-make Main.elm                     # compile to HTML in index.html
elm-make Main.elm --output main.html  # compile to HTML in main.html
elm-make Main.elm --output elm.js     # compile to JS in elm.js
elm-make Main.elm --warn              # compile and report warnings