(import fmt)
;;Tablo yapmak icin cok uygun.
(define (print-angles x)
  (fmt-join num (list x (sin x) (cos x) (tan x)) " "))

  (fmt #t (decimal-align 2 (fix 1 (fmt-join/suffix print-angles (iota 2) nl))))
					;(fmt #f "Result: " dsp nl)
					;(fmt #f "Result: " parse nl)


 (fmt #t (columnar 1 'right 'infinite (line-numbers)
                    " " (fmt-file "big.pgn")))
