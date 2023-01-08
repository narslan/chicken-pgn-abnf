(import csv-abnf
	(prefix abnf abnf:)
	(chicken io)
	srfi-1
	utf8
	
	)

(include "pgnparser-impl.scm")
(define pcsv (make-parser #\tab))
(define-values (fcell _ fcsv) (make-format #\tab))


(define (err s)
  (print "pgn message error on stream: " s)
  (list)) ; ; (out)

(define (->char-list s)
  (if (string? s) (string->list s) s))

(define (red x) (string-append "\x1B[31m" (->string x) "\x1B[0m"))
(define (green x) (string-append "\x1B[32m" (->string x) "\x1B[0m"))
(define (yellow x) (string-append "\x1B[33m" (->string x) "\x1B[0m"))
(define (blue x) (string-append "\x1B[34m" (->string x) "\x1B[0m"))
 (define (magenta x) (string-append "\x1B[35m" (->string x) "\x1B[0m"))
 (define (cyan x) (string-append "\x1B[36m" (->string x) "\x1B[0m"))
(define (bold x) (string-append "\x1B[1m" (->string x) "\x1B[0m"))
(define (underline x) (string-append "\x1B[4m" (->string x) "\x1B[0m"))


(define file-to-string(read-string #f (open-input-file "eco_lichess.tsv")))

;;setup pgn parser
(define pgnparser
  (lambda (s)
    (let* ([tokens (pgn car err `(() ,(->char-list s)))])
      (for-each
       (lambda (t)
	 (let* ([token-key (first t)]
		[token-value (second t)])
	   (printf "~S ~S" token-key token-value))
	 (newline)
	 )
       tokens))))


(let ((res (pcsv (->char-list file-to-string))))
  (for-each (lambda (record)
	      (let ([openingName  (second record)]
		    [pgnSource  (third record)]
		    [uciSource  (fourth record)]
		    [fenSource  (fifth record)]
		    )
		(pgnparser pgnSource)
		)

	      (begin

		(print (underline(blue(second record)))) ;;name
		(print (underline(red(third record))))   
		(print (green(fourth record)))
		(print (fifth record))
		(newline)
		)
	      
	      )
	    (map csv-record->list res)))

