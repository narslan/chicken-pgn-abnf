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

(define fws
  (abnf:concatenation
   (:?
    (abnf:concatenation
     (:* abnf:wsp)
     (:* 
      (abnf:alternatives abnf:crlf abnf:lf abnf:cr))))
   (:+ abnf:wsp)))


(define (between-fws p)
  (abnf:concatenation
   (:! (:* fws)) p 
   (:! (:* fws))))

;a PGN tag is enclosed with []
(define begin-tag (:! (abnf:char #\[ )))
(define end-tag (:! (abnf:char #\] )))
;a PGN tag has a predefined string after [ 
(define tag-key
  (abnf:bind-consumed->string
   (:* abnf:alpha)))


(define atext
  (abnf:alternatives
   abnf:alpha abnf:decimal (abnf:set-from-string ":,!#$%&'*+-/=?^_`{|}~.")))


;; Quoted characters
(define quoted-pair
  (abnf:concatenation
   (:*
    (abnf:alternatives atext abnf:wsp)
    )
   ))
					; a tag value is  
(define tag-value
  (abnf:bind-consumed->string
   (abnf:concatenation
    (:! abnf:dquote)
    quoted-pair
    (:! abnf:dquote)
    )))


(define tag
  (abnf:concatenation
   begin-tag
   tag-key
   (:! abnf:wsp)
   tag-value
   end-tag
   (:!
    (abnf:repetition
     (abnf:set-from-string "\r\n")))))


;; Move definitons.

(define annotation-symbol 
  (abnf:set-from-string "=?!+#" ))
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
  (:! (abnf:char #\.)))
(define lwsp
  (:! abnf:lwsp))

(define castling
  (abnf:concatenation
   (abnf:lit "O-O")
   (:?
    (abnf:lit "-O"))
   (:?
    (abnf:lit "+"))
   ))

(define result-text
 (abnf:bind-consumed->string
  (abnf:concatenation
   (:+
   (abnf:alternatives
    (abnf:char #\1 )
    (abnf:char #\2 )
    (abnf:char #\0 )
    (abnf:char #\* )
    (abnf:char #\/ )
    (abnf:char #\- )
    )))

   ))

(define result (between-fws result-text ))
	
(define movetext-between-spaces
   (abnf:bind-consumed->string
    (abnf:alternatives
     castling
     (abnf:concatenation
      (abnf:alternatives file piece)
      (abnf:alternatives file capturechar piece rank)
      (:*
       (abnf:alternatives file piece capturechar rank annotation-symbol))
      )     
     )))

(define move-text (between-fws movetext-between-spaces ))

;move-number is the first ("3. ") number before the dot in the move..
(define move-decimal
  (abnf:concatenation
   (abnf:bind-consumed->string
    (:+ abnf:decimal))
   dotchar
   lwsp))

;; Unicode variant of ctext
(define unicode-ctext
  (abnf:set
   (char-set-union
    (char-set-difference char-set:graphic (char-set #\{ #\} #\\))
    (char-set-difference char-set:full  char-set:ascii))))

(define comment
  (abnf:bind-consumed->string
   (abnf:concatenation 
    (:! (abnf:char #\{) )
    (:*
     (abnf:concatenation
      (:? fws)
      unicode-ctext))
    (:? fws)
    (:! (abnf:char #\}))
    )))

(define comment-text (between-fws comment ))
				;move is a single move (3. Qe3!)
(define move
  (abnf:concatenation
   move-decimal
   move-text
   (:? comment-text)
   move-text
   (:? comment-text)
   
   ))


(define all-tags (:* tag))
(define all-moves (abnf:concatenation
		   (:+ move)
		   (:+ result-text)
		   ))

(define game-body
  (abnf:concatenation
   all-tags
   lwsp
   all-moves
   ))

(define game (between-fws game-body ))
(define pgn  (:+ game))


;;(define read-pgn
;;  (read-string #f (open-input-file "big.pgn"))
;;
;;)

;;
;;


					;(define parse-begin-tag (lex begin-tag err "["))

					;(define parse (lex pgn err read-pgn))



