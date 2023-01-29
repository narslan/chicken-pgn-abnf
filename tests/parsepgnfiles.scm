(import 
  (chicken string)
  (chicken io)
  (chicken process-context)
   
   )
  
(include-relative "../pgn-abnf-impl.scm")
(define (string->input-stream s) (string->list s))
(define (err s)
  (print "pgn message error on stream: " s)
  (list))


;return a list of games 
(define (make-pgn-parser s)
  (let
      ([p (pgn-db (compose reverse car) err `(() ,(string->input-stream s)))])
    (print p)))

(define read-pgn-file (read-string #f (open-input-file (car (command-line-arguments)))))


;return a list of games 

(make-pgn-parser read-pgn-file )

