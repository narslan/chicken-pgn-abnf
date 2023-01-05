(import 
	(chicken io)
	(prefix abnf abnf:) 
	(prefix abnf-consumers abnf:)
	(only lexgen lex)
	test
	fmt
	srfi-1
	(only utf8-srfi-14 char-set char-set-difference char-set-union
	      char-set:graphic char-set:printing char-set:ascii char-set:full
	      )
	)

(define tagText
  (abnf:alternatives
   abnf:alpha abnf:decimal
   (abnf:set-from-string ",.!#$%&'*+-/=?^_`{|}~")))



(define begin-tag (abnf:drop-consumed (abnf:char #\[ )))
(define end-tag (abnf:drop-consumed (abnf:char #\] )))
(define text
  (abnf:set (char-set-difference
	     char-set:ascii
	     (char-set (integer->char 0)
		       (integer->char 10)
		       (integer->char 13)
	      ))))
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
(define parse-begin-tag (lex begin-tag err "["))
(define parse (lex pgn err read-pgn))


