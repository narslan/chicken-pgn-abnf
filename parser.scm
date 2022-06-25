(import (chicken io)
				(prefix abnf abnf:) 
				(prefix abnf-consumers abnf:) 
				)


(define atext
  (abnf:alternatives
   abnf:alpha abnf:decimal
   (abnf:set-from-string ",.!#$%&'*+-/=?^_`{|}~")))

(define Atom
  (abnf:bind-consumed->string (abnf:repetition1 atext)))

(define ws (abnf:repetition (abnf:set-from-string " \t\r\n")))
;(define ws (abnf:drop-consumed (abnf:repetition abnf:wsp)))

(define lf (abnf:drop-consumed (abnf:repetition1 abnf:lf)))
(define nl (abnf:drop-consumed (abnf:repetition1 (abnf:set-from-string "\r\n"))))

(define begin-tag (abnf:drop-consumed (abnf:char #\[ )))
(define end-tag (abnf:drop-consumed (abnf:char #\] )))
(define punkt (abnf:drop-consumed (abnf:char #\. )))
(define score-one (abnf:drop-consumed (abnf:char #\1 )))
(define score-two (abnf:drop-consumed (abnf:char #\2 )))
(define score-zero (abnf:drop-consumed (abnf:char #\0 )))
(define score-slash (abnf:drop-consumed (abnf:char #\/ )))
(define score-dash (abnf:drop-consumed (abnf:char #\- )))
(define score-draw (abnf:concatenation
										score-one
										score-slash
										score-two
										ws
										score-dash
										ws
										score-one
										score-slash
										score-two ))
(define score-first (abnf:concatenation
										 score-one
										 ws
										 score-dash
										 ws
										 score-zero))
(define score-second (abnf:concatenation
											score-one
											ws
											score-dash
											ws
											score-zero))
(define score (abnf:alternatives
							 score-first
							 score-second
							 score-draw
							 ))

(define quoted-string
  (abnf:bind-consumed->string 
   (abnf:concatenation
    (abnf:drop-consumed abnf:dquote) 
    (abnf:optional-sequence
		 (abnf:repetition1
      (abnf:alternatives atext abnf:wsp ))
		 ) 
    (abnf:drop-consumed abnf:dquote))))

(define tag
	(abnf:bind-consumed->string
	 (abnf:concatenation
		begin-tag
		Atom
		ws
		quoted-string
		end-tag
		lf)))

(define roster
	(abnf:concatenation
	 (abnf:repetition1 tag)
	 lf
	 ))

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
		(abnf:drop-consumed (abnf:char #\.))		)))

(define move
		(abnf:concatenation	mnumber matom ws	matom ws))
(define moves
	(abnf:repetition1
	 move
	 ))

(define move-block
	(abnf:repetition1
	 (abnf:concatenation
		moves
		nl))
	)

(define pgn
	(abnf:concatenation
	 roster
	 move-block
	 ))
(define (->char-list s)
  (if (string? s) (string->list s) s))


(define (err s)
  (print "PGN parser error on stream: " s)
  `(error))


(define parser
  (lambda (s)
    (pgn car err `(() ,(->char-list s)))))

(define read-kasparov
	(read-string #f (open-input-file "little.pgn")))

(parser read-kasparov)


