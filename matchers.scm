;;abbreviatons for some regularly used procedures. 
(define :? abnf:optional-sequence)
(define :! abnf:drop-consumed)
(define :* abnf:repetition)
(define :+ abnf:repetition1)

;;folding white space look for at least one space and any crlf 

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

;; matches any number of crlf

(define newlines
  (abnf:drop-consumed
   (:* 
    (abnf:set-from-string "\r\n"))) )
  
;;TAG
;;this is a PGN tag => [TAGKEY "TAGVALUE"]
;; we define here matchers that makes up a tag
(define begin-tag (:! (abnf:char #\[ )))
(define end-tag (:!   (abnf:char #\] )))


;; Matches any US-ASCII character except for nul \r \n
(define text
  (abnf:set (char-set-difference
             char-set:ascii 
             (char-set (integer->char 0) 
                       (integer->char 10) 
                       (integer->char 13)
		       
		       ))))

;; Unicode variant of text
(define unicode-text
  (abnf:set (char-set-union
             (char-set-difference
              char-set:ascii 
              (char-set (integer->char 0) 
                        (integer->char 10) 
                        (integer->char 13) ))
             (char-set-difference
              char-set:full 
              char-set:ascii))))

;; ttext matches any ascii character except "
(define ttext
  (abnf:set (char-set-difference char-set:ascii (char-set #\" ))))

;;unicode variant of ttext
(define unicode-ttext
  (abnf:set (char-set-union
	     (char-set-difference
	      char-set:ascii
	      (char-set (integer->char 22) ))
	     (char-set-difference
              char-set:full 
              char-set:ascii))))

;; unicode-ctext matches unicode characters for the comments.
(define unicode-ctext
  (abnf:set
   (char-set-union
    (char-set-difference char-set:graphic (char-set #\{ #\} #\\))
    (char-set-difference char-set:full  char-set:ascii))))
