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
	  ("[Event \"Havana m.\"]"  ("Havana m." "Event") ())
	  ("[Event \"Havana m.\"]\n"  ("Havana m." "Event") ())
	  ("[Event \"Havana m.\"]\r\n"  ("Havana m." "Event") ())
	  ))

       (tag-multiline-cases
	`(
	  ("[Event \"Havana m.\"]\r\n[EventTest \"Havana2\"]"  ("Havana2" "EventTest" "Havana m." "Event") () )
	  ))

       (move-text-cases
	`(
	  ("e4"    ("e4")    ())
	  ("Nf3"   ("Nf3")   ())
	  ("bxc3"  ("bxc3")  ())
	  ("axb6"  ("axb6")  ())
	  ("Qxb6" ("Qxb6") ())
	  ("axb6#" ("axb6#") ())
	  ("O-O" ("O-O") ())
	  ("O-O-O" ("O-O-O") ())
	   
	  )))


  (test-group "tags"
    (for-each (lambda (p)
		(let ((inp (first p))
		      (res (second p)))
		  (let ((is (string->input-stream inp)))
		    (tag (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
	      tag-cases))

   (test-group "multiline-tags"
    (for-each (lambda (p)
		(let ((inp (first p))
		      (res (second p)))
		  (let ((is (string->input-stream inp)))
		    (pgn (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
	      tag-multiline-cases))

(test-group "move-text-cases"
    (for-each (lambda (p)
		(let ((inp (first p))
		      (res (second p)))
		  (let ((is (string->input-stream inp)))
		    (move-text (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
	      move-text-cases))
   )






(test-exit)

  
