(import 
  (chicken string)
  (chicken format)
  (chicken port)
  (chicken io)
  (chicken file posix)
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
	       [sl '()] ;; contains the positions where the file will be splitted
	       [nsl 0] ;; how many split points do we have?
	       )
      (if (eof-object? c)
          (begin
	    (print "line numbers"  " " k)
	    (print "split lines"  " " sl)
	    (print "number of split"  " " nsl)
	    (close-input-port fh))
	  (begin
	    (if (result-line? c)
		(begin
		  ;;(print "position last" (file-position fh) )
		  (set! sl (append sl `(,(file-position fh))))
		  (set! nsl (+ 1 nsl))
		  )
		(begin
		  ;;(print "position" (file-position fh) )
		  		  
		  ))
	    (loop (read-line fh) (+ k 1) sl nsl))))))



;;(time (read-it "testdata/1.pgn"))
(time (read-it "testdata/Adams.pgn"))

(test-exit)
