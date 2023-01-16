(import 
  test
  srfi-1
  (chicken format)
  pgn-abnf
  )

(define (string->input-stream s) `(() ,(string->list s)))
(define (err s)
  (print "pgn message error on stream: " s)
  (list)) 

(let* ((tag-cases
        `(
          ("[Event \"Havana    m.   \"]"  (( tag "Event"  "Havana    m.   ")) ())
          ("[Event \"Havana m.\"]\n" ((tag "Event" "Havana m.") ) ())
	  ("[Event \"Havana m.\"]\r\n" ((tag "Event" "Havana m.") ) ())

	  ))
       
       (move-cases
        `(
          ("1.e4 e5 "       ((move "e4"  "e5") )    ())
          ("29. Ng6 Nf4 "   ((move "Ng6" "Nf4") )   ())
	  ("29. O-O O-O-O "   ((move "O-O" "O-O-O") )   ())
          ("45. Bc3 Qe8+ "   ((move "Bc3"  "Qe8+" ) ))))
       
)

 (test-group "tags"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (pgn-tag (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      tag-cases))


 (test-group "moves"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (pgn-move (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      move-cases))
 )



(test-exit)

  

