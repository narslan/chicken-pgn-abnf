(import 
	(chicken io)
	(chicken base)
	(prefix abnf abnf:) 
	(prefix abnf-consumers abnf:)
	(only lexgen lex)
	test
	(only utf8-srfi-14 char-set char-set-difference char-set-union
	      char-set:graphic char-set:printing char-set:ascii char-set:full))


;;abbreviatons for some repeatedly used procuders. 
(define :? abnf:optional-sequence)
(define :! abnf:drop-consumed)
(define :* abnf:repetition)
(define :+ abnf:repetition1)

;;following two definitions are from iraikov/internet-message
;;they stand for Folding white space. It is very useful for this library.
;;side remark: fws matches lots of space. (\s*(?![\r\n]+)?\s+?
(define fws
  (abnf:concatenation
   (:?
    (abnf:concatenation
     (:* abnf:wsp)
     (:* 
      (abnf:alternatives abnf:crlf abnf:lf abnf:cr))))
   (:+ abnf:wsp)))

;;look everything between ~lots of space~ and  ~lots of space~
(define (between-fws p)
  (abnf:concatenation
   (:! (:* fws)) p 
   (:! (:* fws))))

;;this is a PGN tag => [TAGKEY "TAGVALUE"]
(define begin-tag (:! (abnf:char #\[ )))
(define end-tag (:! (abnf:char #\] )))
(define tag-key
  (abnf:bind-consumed-strings->list
   'tagkey
   (abnf:bind-consumed->string
    (:* abnf:alpha))))

;;from iraikov/internet-message
;;matches a sequence of whitespace characters
(define tagtext-characters
  (abnf:alternatives
   abnf:alpha abnf:decimal (abnf:set-from-string "():,!#$%&'*+-/=?^_`{|}~.")))

;;matches a sequence of characters and whitespace 
(define tagtext
  (abnf:concatenation
   (:*
    (abnf:alternatives tagtext-characters abnf:wsp))))

       ;; a tag value is  
(define tag-value
  (abnf:bind-consumed-strings->list
   'tagvalue
   (abnf:bind-consumed->string
    (abnf:concatenation
     (:! abnf:dquote)
     tagtext
     (:! abnf:dquote)))))

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

(define castling-chars
  (abnf:alternatives
   annotation-symbol
   (abnf:set-from-string "O-" )
   )
  )
(define castling
  (abnf:concatenation
   (abnf:lit "O-O")
   (:* castling-chars)
   )
  )

(define result-variations
  
  (abnf:bind-consumed-strings->list
   'result
  (abnf:bind-consumed->string
   (abnf:alternatives
    (abnf:lit "1-0")
    (abnf:lit "0-1")
    (abnf:lit "1/2-1/2")
    (abnf:lit "*")))))
(define result (between-fws result-variations ))

;;move-number is the first ("3. ") number before the dot in the move..
(define move-number
  (abnf:bind-consumed-strings->list
   'movenumber
  (abnf:concatenation
   (abnf:bind-consumed->string
    (:+ abnf:decimal))
   dotchar
   lwsp)))


(define movetext-between-spaces
  (abnf:bind-consumed-strings->list
   'movetext
  (abnf:bind-consumed->string
   (abnf:alternatives
    castling
    (abnf:concatenation
     (abnf:alternatives file piece)
     (abnf:alternatives file capturechar piece rank)
     (:*
      (abnf:alternatives file piece capturechar rank annotation-symbol))   )))))

(define move-text (between-fws movetext-between-spaces ))


;; Unicode variant of ctext
(define unicode-ctext
  (abnf:set
   (char-set-union
    (char-set-difference char-set:graphic (char-set #\{ #\} #\\))
    (char-set-difference char-set:full  char-set:ascii))))

(define comment
  (abnf:bind-consumed-strings->list
   'comment
  (abnf:bind-consumed->string
   (abnf:concatenation 
    (:! (abnf:char #\{) )
    (:*
     (abnf:concatenation
      (:? fws)
      unicode-ctext))
    (:? fws)
    (:! (abnf:char #\}))))))

(define comment-text (between-fws comment ))

;;move is a single move (3. Qe3!)

(define move
(abnf:bind-consumed-strings->list
 'move
 (abnf:concatenation
  move-number
  move-text
  (:? comment-text)
  (:? move-text)
  (:? comment-text)
  (:? result))
 )
  )


(define all-tags (:* tag))


(define all-moves (abnf:concatenation
		   (:+ move)))

(define game-body
  (abnf:concatenation
   all-tags
   lwsp
   all-moves
   ))

(define game (between-fws game-body ))
(define pgn  (:+ game))

