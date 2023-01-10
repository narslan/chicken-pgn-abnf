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
          ("e4 "     (("e4"))    ())
          ("Nf3 "    ("Nf3")   ())
          ("bxc3 "   ("bxc3")  ())
          ("axb6 "   ("axb6")  ())
          ("Qxb6 "   ("Qxb6")  ())
          ("axb6# "  ("axb6#") ())
          (" O-O "   ("O-O") ())
          (" O-O-O "   ( "O-O-O") ())
	  (" O-O-O+ "   ("O-O-O+") ())
	  
	  (" O-O-O+!! "   (("O-O-O+!!")) ())
	  ))
       
       (move-cases
        `(
          ("1.e4 e5 "       (("e4"  "e5") )    ())
          ("29. Ng6 Nf4 "   (("Ng6" "Nf4") )   ())
	  ("29. O-O O-O-O "   (("Ng6" "Nf4") )   ())
          ("45. Bc3 Qe8+ "   (("Bc3"  "Qe8+" ) ))))

       (multiple-move-cases
        `(
          ("1.e4 e5 2. Nf4 Kh3 * "       (("e4"  "e5") )    ())
          ("1.e4 e5 2. Nf4 Kh4 3. h6 "   (("Ng6" "Nf4") )   ())
          ))

        (multiple-tag-cases
        `(
          ("[Event \"Havana m.\"]\n[White \"Jose Capablanca\"]\n"       (("e4"  "e5") )    ())
         
          ))

	 (game-body-cases
        `(
          ("[Event \"Havana m.\"]\n[White \"Jose Capablanca\"]\n1.e4 e5 2.c3 O-O-O "       (("e4"  "e5") )    ())
         
          ))
       
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

(test-group "multiple moves"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (all-moves (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      multiple-move-cases))
(test-group "multiple tags"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (all-tags (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      multiple-tag-cases))
(test-group "game body cases"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (game-body (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      game-body-cases))

 )



(test-exit)

  

