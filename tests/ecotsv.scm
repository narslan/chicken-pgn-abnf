(import csv-abnf
	(prefix abnf abnf:)
	(chicken io)
	(chicken format)
	utf8)

(include "pgnparser-impl.scm")
(define pcsv (make-parser #\tab))
(define-values (fcell _ fcsv) (make-format #\tab))
(define (err s)
  (print "pgn message error on stream: " s)
  (list)) ;

(define (->char-list s)
  (if (string? s) (string->list s) s))


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
	  (newline)))))

(define record-analyze
  (lambda (record)
    (let* ([openingName  (second record)]
	   [pgnSource  (third record)]
	   [uciSource  (fourth record)]
	   [fenSource  (fifth record)]
	   )
      (begin
	(pgnparser pgnSource)))))

(let ((res (pcsv (->char-list file-to-string))))
  (for-each 
   record-analyze
   (map csv-record->list res)))
  
