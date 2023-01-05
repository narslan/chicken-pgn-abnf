(import 
  test
  fmt
  srfi-1 )
(include "neoparser.scm")
(define (->char-list s)
  (if (string? s) (string->list s) s ))
(test-begin "lexer")
(test-group "tag tests"
  (test "begin tag"
	,@(->char-list "heheh")
	parse-begin-tag
	)
    )

(test-end)
