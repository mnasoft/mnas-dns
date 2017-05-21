;;;; mnas-dns.lisp

(in-package #:mnas-dns)

;;; "mnas-dns" goes here. Hacks and glory await!

(defun ip-by-name (name)
"Выполняет определение IP-адреса ПК по его имени;
Возвращает:
первое значение - список IP-адресов, соответствующих данному имени name или NIL;
второе значение - список имен, соответствующих данному имени name или NIL;
Пример использования:
;(ip-by-name \"n000171\")
;=>(\"190.91.112.30\"), (\"n000171.zorya.com\")
;(ip-by-name \"n00017\")
;=> NIL, NIL
"
  (let ((osstr (make-string-output-stream)))
    (uiop:run-program (concatenate 'string "nslookup " name) :output osstr :ignore-error-status t
		      :external-format (cond
					 ((uiop:os-windows-p) :cp1251) 
					 (t uiop/stream:*utf-8-external-format*)
					 ) 
		      )
    (let ((isstr  (make-string-input-stream (get-output-stream-string osstr)))
	  (lst nil)
	  (rez nil)
	  )
      (do ((line (read-line isstr nil 'eof)
		 (read-line isstr nil 'eof)))
	  ((eql line 'eof))
	(setf lst (cons line lst)))
      (setf lst (mapcar #'(lambda (el)
			    (cl-ppcre:split ":" el))
			lst))
      (mapc #'(lambda (el) 
		(if el 
		    (setf rez (cons 
			       (list  (first el) 
				      (string-trim  " 		" (second el)))
			       rez))) ) lst)
      (let ((nm nil)
            (nm-lst nil)
	    (addres nil)
	    (addres-lst nil))
	(dolist (i rez (values addres-lst nm-lst))
	  (if (string= (first i) "Name") (setf nm (second i)))
	  (if (and nm  (string= (first i) "Address"))
	      (setf addres (second i)
		    addres-lst (cons addres addres-lst)
		    nm-lst (cons nm nm-lst))))))))
