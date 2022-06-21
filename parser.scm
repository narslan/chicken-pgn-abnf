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

(define ws (abnf:drop-consumed (abnf:repetition abnf:sp)))

(define lf (abnf:drop-consumed (abnf:lf)))

(define begin-tag (abnf:drop-consumed (abnf:char #\[ )))
(define end-tag (abnf:drop-consumed (abnf:char #\] )))
(define punkt (abnf:drop-consumed (abnf:char #\. )))

(define quoted-string
  (abnf:bind-consumed->string 
   (abnf:concatenation
    (abnf:drop-consumed abnf:dquote) 
    (abnf:repetition1 Atom) 
    (abnf:drop-consumed abnf:dquote))))

(define (String Atom Quoted-string)
  (abnf:alternatives Atom Quoted-string))

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
	(abnf:repetition tag))
(define move
	(abnf:concatenation
	 abnf:decimal
	 punkt
	 Atom
	 ws
	 Atom
	 ws
	 )
	)
(define moveline
	(abnf:concatenation
	 (abnf:repetion move)
	 )
	
	)
(define movetext 
	(abnf:repetion (move))
	)

(define (->char-list s)
  (if (string? s) (string->list s) s))


(define (err s)
  (print "JSON parser error on stream: " s)
  `(error))


(define parser
  (lambda (s)
    (movetext caar err `(() ,(->char-list s)))))

(define read-kasparov
	(read-string #f (open-input-file "little.png")))
(parser read-kasparov)


