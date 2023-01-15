(import 
  test
  (chicken string)
  (chicken format)
  test
  iterators
  )

(include-relative "../pgnparser-impl.scm")
(include-relative "../splitter-matchers.scm")

(define (result-line? line)
  (let* ([tokens (all-moves-with-result car err-plain `(() ,(string->input-stream line)))])
    (if (list? tokens)	#t #f)))

(define (read- file)
  (let ([fh (open-input-file file)])
    (let loop (
	       [c (read-line fh)]
	       [k 0]
	       [chs 0]
	       )
      (if (eof-object? c)
         (begin
	   (print "line numbers"  " " k)
	   (close-input-port fh))
          (begin
	    (loop (read-line fh) (+ k 1) ))))))

(time (read-it "testdata/Adams.pgn"))
