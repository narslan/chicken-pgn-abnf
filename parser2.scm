(import (chicken port)
	(chicken io)
	)
(define (count file)
  (with-input-from-file file 
    (lambda ()
      (port-fold
       (lambda (line lines-so-far) (add1 lines-so-far)) 0 read-line))))
(count "little.pgn")



(define :? optional-sequence)
(define :! drop-consumed)
(define :* repetition)
(define :+ repetition1)

(define-syntax ::
  (syntax-rules () ((_ e1 e2 ...) (concatenation e1 e2 ...))))


