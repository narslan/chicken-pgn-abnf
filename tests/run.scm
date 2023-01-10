(import 
  test
  srfi-1
  (chicken format))

(include "pgnparser-impl.scm")

(define (string->input-stream s) `(() ,(string->list s)))
(define (err s)
  (print "pgn message error on stream: " s)
  (list)) 

(let* ((tag-cases
        `(
          ("[Event \"Havana    m.   \"]"  (tag-record ) ())
          ("[Event \"Havana m.\"]\n" ((tagvalue "Havana m.") (tagkey "Event")) ())
          ("[Event \"Havana m.\"]\r\n"  ((tagvalue "Havana m.") (tagkey "Event")) ())))    

       (tag-multiline-cases
        `(
          ("[Event \"Havana m.\"]\r\n[EventTest \"Havana2\"]"  ("Havana2" "EventTest" "Havana m." "Event") ())))

       (move-text-cases
        `(
          ("e4 "     ((movetext "e4"))    ())
          ("Nf3 "    ((movetext "Nf3"))   ())
          ("bxc3 "   ((movetext "bxc3"))  ())
          ("axb6 \n"   ((movetext "axb6"))  ())
          ("Qxb6 "   ((movetext "Qxb6"))  ())
          ("axb6# "  ((movetext "axb6#")) ())
          (" O-O "   ((movetext "O-O")) ())
          (" O-O-O "   ((movetext "O-O-O")) ())
	  (" O-O-O+ "   ((movetext "O-O-O+")) ())
	  (" O-O-O+! "   ((movetext "O-O-O+!")) ())
	  (" O-O-O+!! "   ((movetext "O-O-O+!!")) ())
	  ))
       ;;TODO: it fails when there is no whitespace around castling expression.
     ;;  ("O-O-O+!"   ((movetext "O-O-O+!!")) ())
       (single-move-cases
        `(
          ("1.e4 e5 "       ((move) (movetext "e5") ( movetext "e4"   ) (movenumber "1"))    ())
          ("29. Ng6 Nf3 "   ((move) (movetext "Nf3") ( movetext "Ng6" ) (movenumber "29"))   ())
          ("45. Nf3 Bc3 "   ((move) (movetext "Bc3") ( movetext "Nf3" ) (movenumber "45")))))
    
       (many-move-cases
        `(
          ("1. c4 Nf3 2. Bf3 Nf6 "    ((move) (movetext "Nf6") (movetext "Bf3") (movenumber "2") (move) (movetext "Nf3") (movetext "c4") (movenumber "1")  )    ())))
    
       (game-cases
        `(
          ("[Event \"Istanbul\"]\n[WhiteELO \"2221\"]\n 1. "
	   ( )    ()))))


 
  
  (test-group "move text cases" (for-each (lambda (p)
					    (let ((inp (first p))
						  (res (second p)))
					      (let ((is (string->input-stream inp)))
						(ply (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
					  move-text-cases))
  
  (test-group "single move cases" (for-each (lambda (p)
					      (let ((inp (first p))
						    (res (second p)))
						(let ((is (string->input-stream inp)))
						  (move (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
					    single-move-cases))

 (test-group "many moves cases" (for-each (lambda (p)
					       (let ((inp (first p))
						     (res (second p)))
						 (let ((is (string->input-stream inp)))
						   (all-moves (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
					     many-move-cases))
   
 (test-group "a game"  (for-each (lambda (p)
				 (let ((inp (first p))
				       (res (second p)))
				   (let ((is (string->input-stream inp)))
				     (game (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			       game-cases))

 (test-group "tags"  (for-each(lambda (p)
				(let ((inp (first p))
				      (res (second p)))
				  (let ((is (string->input-stream inp)))
				    (tag (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
			      tag-cases))

 )


(test-exit)

  

