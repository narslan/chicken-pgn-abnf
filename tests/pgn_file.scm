(import 
  test
  srfi-1
  (chicken format))

(include-relative "../pgnparser-impl.scm")

(define (string->input-stream s) `(() ,(string->list s)))
(define (err s)
  (print "pgn message error on stream: " s)
  (list))


(define (->char-list s) ""
  (if (string? s) (string->list s) s))

;parser returns a list of gams a list of tags
(define parser
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

(define read-pgn(read-string #f (open-input-file "testdata/1.pgn")))

(parser read-pgn)
