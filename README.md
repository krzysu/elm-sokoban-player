# Sokoban Player

Sokoban Player provides best experience to play any [sokoban](https://en.wikipedia.org/wiki/Sokoban) level you want!

Play it [here](https://sokoban-player.netlify.com/)

## Contributing

This app is based on [create-elm-app](https://github.com/halfzebra/create-elm-app).
Here are steps to set it up for yourself.

- `npm install`
- `npm start`

To build app

- `npm run build`

To build SVG sprite

- `npm run build-svg`

Run tests (optional with watch)

- `npm test`
- `npm test -- --watch`

Pull requests are welcome!

## TODO

- rewrite rendering
- stats: remaining boxes count, best score
- HUD
- box on dot change color
- player animation
- touch support
- scale to screen size
- scores, save results to localstorage
- level solver
- make sure it works cross browser (safari rendering bug, IE not rendering at all)

## Some docs

### Level data structures and transformations

#### `StringLevel` and `ShortStringLevel`

Based on [Sokoban Level Format](http://sokobano.de/wiki/index.php?title=Level_format) level can be defined as a string in 2 formats, normal and short. This is one of possible entry formats.

- `StringLevel` - normal, row separation with pipe or just with new line

```
#######
#.@ # #
#$* $ #
#   $ #
# ..  #
#  *  #
#######
```

- `ShortStringLevel` - created from normal with Run Length Encoding, row separation obligatory with pipe, underscore represents an empty field

```
7#|#.@_#_#|#$*_$_#|#3_$_#|#_2.2_#|#2_*2_#|7#|
```

- `XmlLevel`

XML Sokoban format, game elements are represented with the same characters as in string format. Another entry format.

```
<Level Id="soko42" Width="7" Height="9">
    <L> ######</L>
    <L> #    #</L>
    <L>## $  #</L>
    <L>#  ##$#</L>
    <L># $.#.#</L>
    <L># $...#</L>
    <L># $####</L>
    <L>#@ #</L>
    <L>####</L>
</Level>
```

- `Level`

Intermediary structure to standardize all entry formats. `id` is a `UrlEncodedLevel`

```
level : Level
level =
    { width = 5
    , height = 3
    , map =
        [ [ '#', '#', '#', '#', '#' ]
        , [ '#', '@', '$', '.', '#' ]
        , [ '#', '#', '#', '#', '#' ]
        ]
    , id = "5AHABDFAH5A"
    }
```

- `ViewLevel`

Is created always directly from `Level` and is used to keep and update level elements in `Model`.

```
viewLevel : ViewLevel
viewLevel =
    { player = Block 1 1
    , walls = [ Block 0 0, Block 1 0, etc. ]
    , boxes = [ Block 2 1 ]
    , dots = [ Block 3 1 ]
    , gameSize = ( 5, 3 )
    }
```

- `UrlEncodedLevel`

This is `ShortStringLevel` format mapped to more url-friendly symbols, see table below.

```
7AHAFBGAGAHADEGDGAHA3GDGAHAG2F2GAHA2GE2GAH7AH
```

| element | sokoban format | url encoded |
| - | :-: | :-: |
| wall | # | A |
| player | @ | B |
| player on dot | + | C |
| box | $ | D |
| box on dot | * | E |
| dot | . | F |
| floor | _ | G |
| row separator | &#124; | H |
