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
          ("[Event \"Havana    m.   \"]"  (("Event"  "Havana    m.   ")) ())
          ("[Event \"Havana m.\"]\n" (("Event" "Havana m.") ) ())
	  ("[Event \"Havana m.\"]\r\n" (("Event" "Havana m.") ) ())

	  ))
       (ply-cases
        `(
          ("e4"     (( "e4"))    ())
          ("Nf3"    (( "Nf3"))   ())
          ("bxc3"   (( "bxc3"))  ())
          ("axb6"   (( "axb6"))  ())
          ("Qxb6"   (( "Qxb6"))  ())
          ("axb6# "  (( "axb6#")) ())
          ("O-O"   (( "O-O")) ())
          ("O-O-O"   (( "O-O-O")) ())
	  ("O-O-O+"   (( "O-O-O+")) ())
	  ("O-O-O+! "   (( "O-O-O+!")) ())
	  ("O-O-O+!!"   (( "O-O-O+!!")) ())
	  ))
       
       (move-cases
        `(
          ("1.e4 e5 "       (("e5") ( "e4") )    ())
          ("29. Ng6 Nf3 "   (("Nf3") ( "Ng6"))   ())
          ("45. Nf3 Bc3 "   (("Bc3") ( "Nf3" )))))
)

 (test-group "tags"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (tag (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      tag-cases))

 (test-group "plies"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (ply (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      ply-cases))

 (test-group "moves"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (move (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      move-cases))

 )



(test-exit)

  

