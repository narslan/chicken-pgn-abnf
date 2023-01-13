(import csv-abnf
	(prefix abnf abnf:)
	(chicken io)
	(chicken format)
	srfi-1
	utf8
	trace
	)

(include "pgnparser-impl.scm")
(define pcsv (make-parser #\tab))
(define-values (fcell _ fcsv) (make-format #\tab))


(define (err s)
  (print "pgn message error on stream: " s)
  (list)) ;

(define (->char-list s)
  (if (string? s) (string->list s) s))

;;color definitions for output
(define (red x) (string-append "\x1B[31m" (->string x) "\x1B[0m"))
(define (green x) (string-append "\x1B[32m" (->string x) "\x1B[0m"))
(define (yellow x) (string-append "\x1B[33m" (->string x) "\x1B[0m"))
(define (blue x) (string-append "\x1B[34m" (->string x) "\x1B[0m"))
(define (magenta x) (string-append "\x1B[35m" (->string x) "\x1B[0m"))
(define (cyan x) (string-append "\x1B[36m" (->string x) "\x1B[0m"))
(define (bold x) (string-append "\x1B[1m" (->string x) "\x1B[0m"))
(define (underline x) (string-append "\x1B[4m" (->string x) "\x1B[0m"))

;;input source
(define file-to-string(read-string #f (open-input-file "eco_lichess.tsv")))

;;setup pgn parser
(define pgnparser
  (lambda (s)
    (if (equal? s "pgn") '()
	(let* ([tokens (pgn car err `(() ,(->char-list s)))])
	  (for-each
	   (lambda (t)
	     (display t))
	   tokens)
	  (newline)
	  ))))

(define record-analyze
  (lambda (record)
  
    (let* ([openingName  (second record)]
	   [pgnSource  (third record)]
	   [uciSource  (fourth record)]
	   [fenSource  (fifth record)]
	   )
      (begin
	(pgnparser pgnSource)
	) )
    ))

(let ((res (pcsv (->char-list file-to-string))))
  (for-each 
   record-analyze
   (map csv-record->list res)
   ))
  



  

