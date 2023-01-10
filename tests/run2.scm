(import 
  test
  srfi-1
  (chicken format))

(include-relative "../pgnparser-impl.scm")

(define (string->input-stream s) `(() ,(string->list s)))
(define (err s)
  (print "pgn message error on stream: " s)
  (list)) 

(let* ((tag-cases
        `(
          ("[Event \"Havana    m.   \"]"  (tag-record ) ())
          ("[Event \"Havana m.\"]\n" ((tagvalue "Havana m.") (tagkey "Event")) ())
          ("[Event \"Havana m.\"]\r\n"  ((tagvalue "Havana m.") (tagkey "Event")) ())))    
)

 (test-group "tags"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (tag (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      tag-cases))

 )



(test-exit)

  

