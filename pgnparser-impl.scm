(import 
	(chicken io)
	(prefix abnf abnf:) 
	(prefix abnf-consumers abnf:)
	(only lexgen lex)
	test
	(only utf8-srfi-14 char-set char-set-difference char-set-union
	      char-set:graphic char-set:printing char-set:ascii char-set:full))

(include-relative "matchers.scm")

(define-record-type move-record
  (list->move-record elems)
  move-record?
  (elems move-record->list))

(define-record-type tag-record
  (list->tag-record elems)
  tag-record?
  (elems tag-record->list))

(define-record-type game-record
  (list->game-record elems)
  game-record?
  (elems game-record->list))

;Tag

(define tagkey
  (abnf:bind-consumed->string
   (abnf:concatenation (:+ abnf:alpha))))

(define tagvalue
  (abnf:concatenation (:! abnf:dquote)
		      (abnf:bind-consumed->string
		       (:* (abnf:alternatives
			    ttext
			    abnf:wsp)))
		      (:! abnf:dquote)))
 
(define tag (abnf:bind-consumed-strings->list
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
  (abnf:bind-consumed->string
    (abnf:concatenation 
     (:! (abnf:char #\{) )
     (:*
      (abnf:concatenation
       (:? fws)
       unicode-ctext))
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
    (abnf:bind-consumed->string ply) 
    (:* (abnf:alternatives
	 comment
	 (abnf:bind-consumed->string ply) 
	 (abnf:bind-consumed->string result))))))

;used to find end of pgn
(define moves-without-result
  (abnf:bind-consumed-strings->list
   (abnf:concatenation
    movenumber
    (abnf:bind-consumed->string ply) 
    (:* (abnf:alternatives
	 comment
	 (abnf:bind-consumed->string ply) 
	 )))))

(define all-moves-with-result
  (abnf:concatenation
   (:+ moves-without-result)
   (abnf:bind-consumed->string result)
   ))


  (define all-tags
    (:*
     (abnf:concatenation 
      tag
      newlines)))

  (define all-moves 		   (:+ move))
(define game
  (abnf:bind-consumed-strings->list
   'game
   (abnf:concatenation
    all-tags
    all-moves)))

(define pgn (:+ game))


(define-iterator (ping)
  (let loop ()
    (yield 'ping)
    (loop)))

(define-iterator (pong)
  (let loop ()
    (yield 'pong)
    (loop)))

(define (ping-pong n)
  (let loop ((k 0) (ci (coroutine (ping))) (co (coroutine (pong))))
    (cond
      ((= k n)
       (print 'Finish))
      ((< k n)
       (print (co-value ci) " " (co-value co))
       (loop (+ k 1) (co-move ci) (co-move co))))))
