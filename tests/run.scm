(import 
  test
  srfi-1
  (chicken format)
)
(include "neoparser.scm")

(define (string->input-stream s) `(() ,(string->list s)))
(define (err s)
  (print "internet message error on stream: " s)
  (list))

(let* ((tag-cases
	`(
	  ("["  ("") ())
	  ("[Event]"  ("Event") ())
	  ("[Event \"Havana\"]"  ("Havana", "Event") ())
	  ("[Event \"Havana m.\"]"  ("Havana m.", "Event") ())
	  ("[Event \"Havana m.\"]\n"  ("Havana m.", "Event") ())
	  ("[Event \"Havana m.\"]\r\n"  ("Havana m.", "Event") ())
	  ("[Event \"Havana m.\"]\r\n[EventTest \"Havana2\"]"  ("Havana2", "EventTest", "Havana m.", "Event") ())
	  ))
       )
  (test-group "tags"
    (for-each (lambda (p)
		(let ((inp (first p))
		      (res (second p)))
		  (let ((is (string->input-stream inp)))
		    (pgn (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
	      tag-cases))
  )

(test-exit)

  
