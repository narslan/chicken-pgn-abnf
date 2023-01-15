;used to find end of pgn
(define moves-without-result
  (abnf:bind-consumed-strings->list
   (abnf:concatenation
    movenumber
    (abnf:bind-consumed->string ply) 
    (:* (abnf:alternatives
	 comment
	 (abnf:bind-consumed->string ply) 
	 )))))

(define all-moves-with-result
  (abnf:concatenation
   (:+ moves-without-result)
   (abnf:bind-consumed->string result)
   ))
