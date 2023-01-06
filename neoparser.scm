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

(define :? abnf:optional-sequence)
(define :! abnf:drop-consumed)
(define :* abnf:repetition)
(define :+ abnf:repetition1)


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
;; Parses and returns any ASCII characters except "

(define dtext
  (abnf:set 
   (char-set-difference char-set:printing (char-set #\"))))

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
    )))


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


;; Move routines



(define annotation-symbol 
  (abnf:set-from-string "?!+#" ))
(define annotation 
  (abnf:concatenation
   (abnf:repetition
    annotation-symbol)))

(define piece 
  (abnf:set-from-string "KNRBQknrbq" ))
(define rank 
  (abnf:set-from-string "12345678" ))
(define file
  (abnf:set-from-string "abcdefgh" ))
(define capturechar
  (abnf:char #\x ))
(define checkchar
  (abnf:char #\+ ))
(define sharpchar
  (abnf:char #\# ))
(define dotchar
  (abnf:drop-consumed (abnf:char #\.)))
(define castling
  (abnf:concatenation
   (abnf:lit "O-O")
   (abnf:repetition
    (abnf:lit "-O"))))

(define lwsp
  (abnf:drop-consumed abnf:lwsp))

(define fws
  (abnf:concatenation
   (:?
    (abnf:concatenation
     (:* abnf:wsp)
     (:! 
      (abnf:alternatives abnf:crlf abnf:lf abnf:cr))))
   (:+ abnf:wsp)))


(define (between-fws p)
  (abnf:concatenation
   (:! (:* fws)) p 
   (:! (:* fws))))

(define movetext-between-spaces
   (abnf:bind-consumed->string
    (abnf:alternatives
     castling
     (abnf:concatenation
      (abnf:alternatives file piece)
      (abnf:alternatives file capturechar piece rank)
      (:*
       (abnf:alternatives file piece rank annotation-symbol)))
     )))

(define move-text (between-fws movetext-between-spaces ))

					;move-number is the first ("3. ") number before the dot in the move..
(define move-decimal
  (abnf:concatenation
   (abnf:bind-consumed->string
    (abnf:repetition abnf:decimal))
   dotchar
   lwsp))

;move is a single move (3. Qe3!)
(define move
  (abnf:concatenation
   move-decimal
   move-text
   move-text
))


(define all-moves
  
(abnf:repetition
    move
    ))


(define pgn
  (abnf:concatenation
   (abnf:repetition
    tag)))
 


;;(define read-pgn
;;  (read-string #f (open-input-file "big.pgn"))
;;
;;)

;;
;;


;(define parse-begin-tag (lex begin-tag err "["))

					;(define parse (lex pgn err read-pgn))



