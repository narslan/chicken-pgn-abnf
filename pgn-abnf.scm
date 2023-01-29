(module
    (pgn-abnf)
    (pgn-db
      pgn-game
      pgn-tag
      pgn-move
      pgn-tag-list
      pgn-move-list
      pgn-all-moves-with-result)
  (import (chicken base))
  (include "pgn-abnf-impl.scm"))
