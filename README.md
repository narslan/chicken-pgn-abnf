
`pgn-abnf`
PGN (Portable Game Notation) parser for Chicken Scheme. 

## Description
This library contains procedures for parsing PGN database files as described
[Standard: Portable Game Notation Specification](http://www.saremba.de/chessgml/standards/pgn/pgn-complete.htm)   

### Core rules

<procedure>
(pgn-game STRING) => LIST  ;; parsed tokens of a single game
</procedure>

<procedure>
(pgn-db STRING) => LIST  ;; list of games
</procedure>


TODOs:
- [x] a file splitter utility function that split big pgn files efficently. 
  - [] the splitter facility needs more twist
  - [] turn that in a application (cli)
  - [] write in smaller files
  - [] write in a database
    - [] couchdb
    - [] lmdb
  - [] publish via websocket
- [] define-record-type to construct record types from moves and tags as in `csv-abnf-parser`. 
- [] Publishing the egg for indexing.

```

`pgn-abnf` uses the `chicken-abnf` pattern matcher library  to construct the parser. 
I'm mostly thankful to [chicken-abnf](https://github.com/iraikov/chicken-abnf) . 
