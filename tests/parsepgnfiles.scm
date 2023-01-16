(import 
  test
  (chicken string)
  (chicken format)
  )

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


(define (string->input-stream s) (string->list s) )
(define (err s)
  (print "pgn message error on stream: " s)
  (list))

(define (err-plain s)
  'error)

;return a list of games a list of tags
(define (extract-games s)
  (let* (
	 [tokens (reverse (pgn car err `(() ,(string->input-stream s))))]
	 [counter 0])
    (for-each
     (lambda (t)
       (cond ((equal? 'move (car t)) (print (green (cdr t))) )
	     ((equal? 'tag (car t)) (print (blue (cdr t))) )
	     (else (print t)))
       )
     tokens)))
 ;; ((equal? 'tag-record (car t)) (print (blue (cdr t))) )
 ;; 	       ((equal? 'game-record (car t)) (
 ;; 					       print (yellow (car t))) )

(test "WITH COMMENT" '()
      (begin
        (define read-pgn-string(read-string #f (open-input-file "testdata/zahak_zatour.pgn")))
        (time (extract-games read-pgn-string))
        '()))

(test "SIMPLE" '()
      (begin
        (define read-pgn-string(read-string #f (open-input-file "testdata/simple.pgn")))
        (time (extract-games read-pgn-string))
        '()))


;;(define read-pgn-string(read-string #f (open-input-file "testdata/zahak_zatour.pgn"))) 
;;(define read-pgn-iterativ(read-it "testdata/1.pgn"))
;(time read-pgn-iterativ)

(test-exit)
