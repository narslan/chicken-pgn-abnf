(import 
  (chicken string)
  (chicken format)
  (chicken port)
  (chicken io)
  test
  ;;iterators
  pgn-abnf
  )


(define (string->input-stream s) (string->list s) )
(define (err-plain s)  'error)

(define (result-line? line)
  (let* ([tokens (all-moves-with-result car err-plain `(() ,(string->input-stream line)))])
    (if (list? tokens)	#t #f)))

(define (read-it file)
  (let ([fh (open-input-file file)])
    (let loop ([c (read-line fh)]
	       [k 0]
	       [sl 0]
	       )
      (if (eof-object? c)
          (begin
	    (print "line numbers"  " " k)
	    (print "char numbers numbers"  " " sl)
	    (close-input-port fh))
	  (begin
	    (if (result-line? c)
		(begin
		  (print "position last" (port-position fh) )
		  (print "port: in result line true")
		  (set! sl (+ sl  (string-length c)))
		  )
		(begin
		  (print "position" (port-position fh) )
		  (print "port: in result line false")
		  (set! sl (+ sl  (string-length c)))
		  ))
	    (loop (read-line fh) (+ k 1) sl ))))))



(time (read-it "testdata/1.pgn"))
;;(time (read-mit "testdata/Adams.pgn"))

