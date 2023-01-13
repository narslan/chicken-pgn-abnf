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
;;tagvalues consist

(define ttext
  (abnf:set (char-set-difference char-set:ascii (char-set #\" ))))
(define unicode-ttext
  (abnf:set (char-set-union
	     (char-set-difference
	      char-set:ascii
	      (char-set (integer->char 22) ))
	     (char-set-difference
              char-set:full 
              char-set:ascii)
    )))
