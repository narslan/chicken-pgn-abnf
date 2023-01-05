(import 
	(chicken io)
	(prefix abnf abnf:) 
	(prefix abnf-consumers abnf:)
	(only lexgen lex)
	test
	fmt
	
	(only utf8-srfi-14 char-set char-set-difference char-set-union
	      char-set:graphic char-set:printing char-set:ascii char-set:full
	      )
	)
(define char-set:quoted (char-set-difference char-set:printing (char-set #\\ #\")))




(define begin-tag (abnf:drop-consumed (abnf:char #\[ )))
(define end-tag (abnf:drop-consumed (abnf:char #\] )))
(define text
  (abnf:set (char-set-difference
	     char-set:ascii
	     (char-set (integer->char 0)
		       (integer->char 10)
		       (integer->char 13)
		       (integer->char 22)
	      ))))
;; Parses and returns any ASCII characters except [ ] and \

(define dtext
  (abnf:set 
   (char-set-difference char-set:printing (char-set #\[ #\] #\\ #\"))))

(define tag-key
  (abnf:bind-consumed->string
   (abnf:repetition abnf:alpha)
   ))

(define tag-value
  (abnf:bind-consumed->string
   (abnf:concatenation
    (abnf:drop-consumed abnf:dquote)
    (abnf:repetition     dtext )
    (abnf:drop-consumed abnf:dquote)
    )
   ))

(define tag
  (abnf:concatenation
   begin-tag
   tag-key
   (abnf:drop-consumed abnf:wsp)
   tag-value
   end-tag
   (abnf:drop-consumed
    (abnf:repetition1
     (abnf:set-from-string "\r\n")))))



(define pgn
  (abnf:concatenation
   (abnf:repetition
    tag
    )

   ))
 


;;(define read-pgn
;;  (read-string #f (open-input-file "big.pgn"))
;;
;;)

;;
;;


;(define parse-begin-tag (lex begin-tag err "["))

					;(define parse (lex pgn err read-pgn))



