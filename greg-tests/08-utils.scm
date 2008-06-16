
(greg-testcase "Test key symbols" #t
   (lambda ()

     (add-key-binding "name" "missing key" (lambda () 'flunk))

     (test-list (list 
		 (cons (key-sym-code 'a-symbol) -1)
		 (cons (key-sym-code (list 'a 'b)) -1)
		 (cons (key-sym-code "A") 65)
		 (cons (key-sym-code "a") 97)
		 (cons (key-sym-code "9") 57)
		 (cons (key-sym-code "cent") 162)
		 (cons (key-sym-code ">") 62)
		 (cons (key-sym-code ";") 59)
		 (cons (key-sym-code "|") 124)))))
		 


(greg-testcase "Test running a Python function" #t 
   (lambda ()

     (if (not (coot-has-python?))
	 #t ; pass without testing
	 (let ((tot (run-python-command "2 + 4")))
	   (if (not (= 6 tot))
	       #f
	       (run-python-command "test_val = 2")
	       (let ((rv (run-python-command "test_val")))
		 (if (not (= rv 2))
		     #f
		     ;; coot does not convert a tuple.
		     (let ((rv2 (run-python-command "test_val_2 = (1,2,3)")))
		       (run-python-command "test_val_2") ; doesn't crash?
		       #t))))))))


		     
; skip this for now.
;(greg-testcase "Internal/External Molecule Numbers match" #t 
;   (lambda ()

;     (let ((m (molecule-number-list)))
;       (equal? m (map own-molecule-number m)))))

