(module pgn
  *
  (import
    scheme (chicken base)
    (chicken io)
    (prefix abnf abnf:) 
    (prefix abnf-consumers abnf:)
    (only lexgen lex)
  test
  (only utf8-srfi-14 char-set char-set-difference char-set-union
	char-set:graphic char-set:printing char-set:ascii char-set:full))

(include-relative "matchers.scm")

(define tagkey
  (abnf:bind-consumed->string
   (abnf:concatenation (:+ abnf:alpha))))

(define tagvalue
  (abnf:concatenation
   (:! abnf:dquote)
   (abnf:bind-consumed->string (:* ttext))
   (:! abnf:dquote)))

(define tag
  (abnf:bind-consumed-strings->list
   'tag
   (abnf:concatenation
    begin-tag
    tagkey
    (:! abnf:wsp)
    tagvalue
    end-tag)))

;;Move

(define piece  (abnf:set-from-string "KNRBQknrbq" ))
(define rank  (abnf:set-from-string "12345678" ))
(define file  (abnf:set-from-string "abcdefgh" ))
(define capturechar  (abnf:char #\x ))
(define checkchar  (abnf:char #\+ ))
(define sharpchar  (abnf:char #\# ))
(define dotchar  (:! (abnf:char #\.)))
(define lwsp  (:! abnf:lwsp))
(define annotation (abnf:set-from-string "=?!+#"))

(define castling
  (abnf:concatenation
   (abnf:lit "O-O")
   (:?
    (abnf:lit "-O"))
   (:* annotation)))

(define result-variations
  (abnf:alternatives
    (abnf:lit "1-0")
    (abnf:lit "0-1")
    (abnf:lit "1/2-1/2")
    (abnf:lit "*")))

(define result (between-fws result-variations ))

(define comment-text
  (:!
    (abnf:concatenation
     (:! (abnf:char #\{) )
     (:*
      (abnf:concatenation
       (:? fws)
       ctext
       (:? fws)
       ))
     (:? fws)
     (:! (abnf:char #\})))))

(define comment (between-fws comment-text ))

(define movenumber
  (:!
   (abnf:concatenation
    (:+ abnf:decimal)
    dotchar
    lwsp)))

(define ply-text
  (abnf:alternatives
    castling
    (abnf:concatenation
     (abnf:alternatives file piece)
     (abnf:alternatives file capturechar piece rank)
     (:* (abnf:alternatives file piece capturechar rank annotation)))))
 
(define ply (between-fws ply-text ) )

(define move
  (abnf:bind-consumed-strings->list
   'move
   (abnf:concatenation
    movenumber
    (:* (abnf:alternatives
	 comment
	 (abnf:bind-consumed->string ply)
	 (abnf:bind-consumed->string result))))))


(define all-tags
  (:*
   (abnf:concatenation
    tag
    newlines)))

(define all-moves (abnf:concatenation
                   (:*
                    (abnf:alternatives
                     comment
                     move))))

(define game
  (abnf:bind-consumed-strings->list
   'game
   (abnf:concatenation
    all-tags
    all-moves)))

(define pgn (:+ game))

)


