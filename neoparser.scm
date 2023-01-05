(import 
	(chicken io)
	(prefix abnf abnf:) 
	(prefix abnf-consumers abnf:)
	(only lexgen lex)
	test
	fmt
	srfi-1
	)

(define tagText
  (abnf:alternatives
   abnf:alpha abnf:decimal
   (abnf:set-from-string ",.!#$%&'*+-/=?^_`{|}~")))



(define begin-tag (abnf:drop-consumed (abnf:char #\[ )))
(define end-tag (abnf:drop-consumed (abnf:char #\] )))

(define tag
 (abnf:concatenation
   begin-tag
   tagText
   end-tag
   (abnf:drop-consumed
     (abnf:repetition1
      (abnf:set-from-string "\r\n")))
   ))

(define pgn
  (abnf:repetition tag))
 
(define (err s)
  (print "lexical error on stream: " s)
  `(error))
(define read-pgn
	(read-string #f (open-input-file "big.pgn")))

(define parse (lex roster err read-pgn))


