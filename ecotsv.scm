(import csv-abnf
	(prefix abnf abnf:)
	(chicken io)
	srfi-1
	utf8

	)


(define pcsv (make-parser #\tab))
(define-values (fcell _ fcsv) (make-format #\tab))

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

(let ((res (pcsv (->char-list file-to-string))))
  (for-each (lambda (record)
	      (begin
		(print (blue(second record)))
		(print (red(third record)))
		(print (green(fourth record)))
		(print (fifth record))
	       )
	     )

	    (map csv-record->list res)))
