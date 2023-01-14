(import 
  test
  (chicken string)
  (chicken format)
  test
  iterators
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

;parser returns a list of games a list of tags
(define (extract-games s)
   (let* (
	   [tokens (reverse (pgn car err `(() ,(string->input-stream s))))]
	   [counter 0])
      (for-each
       (lambda (t)
	 (cond ((equal? 'move-record (car t)) (display (green (cdr t))) )
	       ((equal? 'tag-record (car t)) (print (blue (cdr t))) )
	       (else (print t)))
	 )
       tokens)))
 ;; ((equal? 'tag-record (car t)) (print (blue (cdr t))) )
 ;; 	       ((equal? 'game-record (car t)) (
 ;; 					       print (yellow (car t))) )
(define (read-it file)
  (let ([fh (open-input-file file)])
    (let loop ([c (read-line fh)])
      (if (eof-object? c)
          (close-input-port fh)
          (begin
	    
            (loop (read-line fh)))))))


(define read-pgn-string(read-string #f (open-input-file "testdata/1.pgn")))
(define read-pgn-iterativ(read-it "testdata/1.pgn"))
(time (extract-games read-pgn-string))


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



;; (ping-pong 10)


(test-exit)
