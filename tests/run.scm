(import 
  test
  srfi-1
  (chicken format))

(include "neoparser.scm")

(define (string->input-stream s) `(() ,(string->list s)))
(define (err s)
  (print "pgn message error on stream: " s)
  (list)) ; ; (out) 

(let* ((tag-cases
        `(
          ("[Event \"Havana    m.   \"]"  ("Havana    m.   " "Event") ())
          ("[Event \"Havana m.\"]\n"  ("Havana m." "Event") ())
          ("[Event \"Havana m.\"]\r\n"  ("Havana m." "Event") ()))) ; ; (out) 
    

       (tag-multiline-cases
        `(
          ("[Event \"Havana m.\"]\r\n[EventTest \"Havana2\"]"  ("Havana2" "EventTest" "Havana m." "Event") ())))
    

       (move-text-cases
        `(
          ("e4 "    ("e4")    ())
          ("Nf3 "   ("Nf3")   ())
          ("bxc3 "  ("bxc3")  ())
          ("axb6 "  ("axb6")  ())
          ("Qxb6 " ("Qxb6") ())
          ("axb6# " ("axb6#") ())
          ("O-O " ("O-O") ())
          ("O-O-O " ("O-O-O") ())))
    
    
       (single-move-cases
        `(
          ("1.e4 e5 "    ("e5" "e4" "1")    ())
          ("29. Ng6 Nf3 "   ("Nf3" "Ng6" "29")   ())
          ("45. Nf3 Bc3 "   ("Bc3" "Nf3" "45")   ())))
    

       (multiple-move-cases
        `(
          ("1. c4 Nf3 2. Bf3 Nf6  "    ("Nf6" "Bf3" "2" "Nf3" "c4" "1")    ())
	  ("1. d4 e5 2. Nf3 Nf6"    ("Nf6" "Nf3" "2" "e5" "d4" "1")    ())
	  ("1.e4 e5 2. Nf3 Nf6 "    ("Nf6" "Nf3" "2" "e5" "e4" "1")    ())
	  ("1.e4 e5 2. Nf3 Nf6+?    \n 3.Bc3 "    ("Bc3" "3" "Nf6+?" "Nf3" "2" "e5" "e4" "1")    ())
	  ))

       (game-cases
        `(
          ("[Event \"Istanbul\"]\n[WhiteELO \"2221\"]\n 1. c4 Nf3 2. Bf3 Nf6 \n 3. Ka1 *"    ("*" "Ka1" "3" "Nf6" "Bf3" "2" "Nf3" "c4" "1" "2221" "WhiteELO" "Istanbul" "Event" )    ())
	  
	  ))
       )

  (test-group "multiline-tags"
   (for-each (lambda (p)
              (let ((inp (first p))
                    (res (second p)))
               (let ((is (string->input-stream inp)))
                (multi-tags (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
       tag-multiline-cases)) ; ; (out) 
;tests if move text (Nf3) parse.
 (test-group "move-text-cases"
     (for-each (lambda (p)
                (let ((inp (first p))
                      (res (second p)))
                 (let ((is (string->input-stream inp)))
                  (move-text (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
         move-text-cases))
;tests if move text (1. Nf3) parse.
 (test-group "single-move-cases"
     (for-each (lambda (p)
                (let ((inp (first p))
                      (res (second p)))
                 (let ((is (string->input-stream inp)))
                  (move (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
         single-move-cases))

;tests if move text (1. Nf3 Bxc3)  parse.
 (test-group "multiple-move-cases"
     (for-each (lambda (p)
                (let ((inp (first p))
                      (res (second p)))
                 (let ((is (string->input-stream inp)))
                  (pgn (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
         multiple-move-cases))
 
  (test-group "tags"
    (for-each (lambda (p)
               (let ((inp (first p))
                     (res (second p)))
                (let ((is (string->input-stream inp)))
                 (tag (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
        tag-cases))

  
  (test-group "game"
    (for-each (lambda (p)
               (let ((inp (first p))
                     (res (second p)))
                (let ((is (string->input-stream inp)))
                 (game (lambda (s) (test (apply sprintf "~S -> ~S" p) res (car s))) err is))))
        game-cases))

  
 )
(define (->char-list s)
  (if (string? s) (string->list s) s))
(define parser
  (lambda (s)
    (pgn car err `(() ,(->char-list s)))))

(define read-pgn
  (read-string #f (open-input-file "Andersson.pgn"))
  )
(print (parser read-pgn) )

					;end of let-rec*
       
       

(test-exit)

  
