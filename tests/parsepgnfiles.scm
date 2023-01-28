(import 
  (chicken string)
  (chicken io)
  (chicken process-context)
   pgn-abnf
   trace
   )
  

(define (string->input-stream s) (string->list s))
(define (err s)
  (print "pgn message error on stream: " s)
  (list))


;return a list of games a list of tags
(define (extract-games s)
  (let* (
         [tokens (reverse (pgn-db car err `(() ,(string->input-stream s))))]
         [counter 0])
    (for-each
     (lambda (t)
       (cond ((equal? 'move (car t)) (print (cdr t)))
        ((equal? 'tag (car t)) (print (cdr t)))
        (else (print t))))
       
     tokens)))
(define read-pgn-string(read-string #f (open-input-file (car (command-line-arguments)))))
;(trace extract-games )
(extract-games read-pgn-string)
