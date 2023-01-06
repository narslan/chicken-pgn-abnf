(import (chicken io)
        (prefix abnf abnf:) 
        (prefix abnf-consumers abnf:))

(define nl (abnf:repetition (abnf:set-from-string "\r\n")))
(define ws (abnf:repetition (abnf:set-from-string " \t\r\n")))
(define punkt (abnf:char #\.))

(define mtext
  (abnf:alternatives
   abnf:alpha abnf:decimal
   (abnf:set-from-string "!+-/?")))
(define matom
  (abnf:bind-consumed->string (abnf:repetition1 mtext)))

(define mnumber
  (abnf:bind-consumed->string
   (abnf:concatenation
    (abnf:repetition1 abnf:decimal)
    (abnf:drop-consumed (abnf:char #\.)))))

(define move (abnf:concatenation mnumber matom ws matom ws))
(define moves (abnf:repetition1  move))
(define move-text   (abnf:repetition1  moves))

(define (->char-list s)
  (if (string? s) (string->list s) s))
(define (err s)
  (print "PGN parser error on stream: " s)
  `(error))
(define parser
  (lambda (s)
    (move-text car err `(() ,(->char-list s)))))

(define read-kasparov
  (read-string #f (open-input-file "big.pgn")))

;;(parser (read-kasparov))
(print (parser read-kasparov))


