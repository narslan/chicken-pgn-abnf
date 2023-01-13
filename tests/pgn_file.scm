(import 
  test
  srfi-1
  (chicken string)
  (chicken format))

(include-relative "../pgnparser-impl.scm")

;;color definitions for output
(define (red x) (string-append "\x1B[31m" (->string x) "\x1B[0m"))
(define (green x) (string-append "\x1B[32m" (->string x) "\x1B[0m"))
(define (yellow x) (string-append "\x1B[33m" (->string x) "\x1B[0m"))
(define (blue x) (string-append "\x1B[34m" (->string x) "\x1B[0m"))
(define (magenta x) (string-append "\x1B[35m" (->string x) "\x1B[0m"))
(define (cyan x) (string-append "\x1B[36m" (->string x) "\x1B[0m"))
(define (bold x) (string-append "\x1B[1m" (->string x) "\x1B[0m"))
(define (underline x) (string-append "\x1B[4m" (->string x) "\x1B[0m"))


(define (string->input-stream s) `(() ,(string->list s)))
(define (err s)
  (print "pgn message error on stream: " s)
  (list))


(define (->char-list s) ""
  (if (string? s) (string->list s) s))

;parser returns a list of games a list of tags
(define parser
  (lambda (s)
    (let* (
	   [tokens (reverse (pgn car err `(() ,(->char-list s))))]
	   [counter 0]
	   )
      (for-each
       (lambda (t)
	 (cond ((equal? 'move-record (car t)) (display (red (cdr t))))
	       ((equal? 'tag-record (car t)) (print (blue (cdr t))) )
	       ((equal? 'game-record (car t)) (
					       print (yellow (car t))) )
	       (else (print t))
	       ))
       tokens))))

(define read-pgn(read-string #f (open-input-file "testdata/1.pgn")))

(parser read-pgn)
