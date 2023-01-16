 `pgn-abnf`
PGN (Portable Game Notation) parser for Chicken Scheme. 

## Description
This library contains procedures for parsing PGN database files as described
[Standard: Portable Game Notation Specification](http://www.saremba.de/chessgml/standards/pgn/pgn-complete.htm)   

<procedure>
(pgn-game STRING) => LIST  ;; parsed tokens of a single game
</procedure>

<procedure>
(pgn-db STRING) => LIST  ;; list of games
</procedure>

TODO:
- a file splitter utility function that split big pgn files efficently. 
- using define-record-type to construct record types out of moves and tags 
- add an http client to retrieve pgn files from remote.
###  Sample Usage

```

`pgn-abnf` uses the `chicken-abnf` pattern matcher library  to construct the parser. This library is deeply grateful to [chicken-abnf](https://github.com/iraikov/chicken-abnf) . 