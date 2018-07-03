(in-package #:mnas-dns)

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
    (uiop:run-program
     (concatenate 'string "nslookup " name) :output osstr :ignore-error-status t
     :external-format (cond
			((uiop:os-windows-p) :cp1251) 
			(t uiop/stream:*utf-8-external-format*)))
    (let ((isstr  (make-string-input-stream (get-output-stream-string osstr)))
	  (lst nil)
	  (rez nil))
      (do ((line (read-line isstr nil 'eof)
		 (read-line isstr nil 'eof)))
	  ((eql line 'eof))
	(setf lst (cons line lst)))
      (setf lst (mapcar #'(lambda (el)
			    (cl-ppcre:split ":" el))
			lst))
      (mapc
       #'(lambda (el) (if el
			  (setf rez (cons (list  (first el) (string-trim  " 		" (second el))) rez))))
       lst)
      (let ((nm nil)
            (nm-lst nil)
	    (addres nil)
	    (addres-lst nil))
	(dolist (i rez (values (mapcar #'(lambda (el) (string-trim " " el) ) addres-lst)
			       (mapcar #'(lambda (el) (string-trim " " el) ) nm-lst)))
	  
	  (if (or (string= (first i) "Имя")
		  (string= (first i) "Name"))
	      (setf nm (second i)))
	  (if (and nm  (or (string= (first i) "Address")
			   (string= (first i) "Addresses")))
	      (setf addres (second i)
		    addres-lst (cons addres addres-lst)
		    nm-lst (cons nm nm-lst))))))))


(progn
  (defparameter *os*
    (let ((name "n133619")
	  (osstr (make-string-output-stream)))
      (uiop:run-program
       (concatenate 'string "nslookup " name) :output osstr :ignore-error-status t
       :external-format (cond
			  ((uiop:os-windows-p) :cp1251) 
			  (t uiop/stream:*utf-8-external-format*)))
      osstr))

  (defparameter *is* (make-string-input-stream (get-output-stream-string *os*)))

  (defparameter *rez*
    (let ((lines nil)
	  (isstr *is*))
      (do ((line (read-line isstr nil 'eof)
		 (read-line isstr nil 'eof)))
	  ((eql line 'eof) (mapcar #'(lambda (el) (string-trim "" el) ) (reverse lines))) 
	(push line lines))))
  )

(defun filter (str lst)
  (loop for i in lst when (if (string/= str i) i nil) collect it))

(require :str)
(mapcar
 #'(lambda (el)
     (filter "" (str:split " " el)))
 *rez*)

(allowed-address-list)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ip-by-name (name)
  (format nil "~{~A~^.~}"
	  (loop for i across
	       (sb-bsd-sockets:host-ent-address
		(sb-bsd-sockets:get-host-by-name name))
	     collect i)))


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
    (uiop:run-program
     (concatenate 'string "nslookup " name) :output osstr :ignore-error-status t
     :external-format (cond
			((uiop:os-windows-p) :cp1251) 
			(t uiop/stream:*utf-8-external-format*)))
    (let ((isstr  (make-string-input-stream (get-output-stream-string osstr)))
	  (lst nil)
	  (rez nil))
      (do ((line (read-line isstr nil 'eof)
		 (read-line isstr nil 'eof)))
	  ((eql line 'eof))
	(setf lst (cons line lst)))
      (setf lst (mapcar #'(lambda (el)
			    (cl-ppcre:split ":" el))
			lst))
      (mapc
       #'(lambda (el) (if el
			  (setf rez (cons (list  (first el) (string-trim  " 		" (second el))) rez))))
       lst)
      (let ((nm nil)
            (nm-lst nil)
	    (addres nil)
	    (addres-lst nil))
	(dolist (i rez (values (mapcar #'(lambda (el) (string-trim " " el) ) addres-lst)
			       (mapcar #'(lambda (el) (string-trim " " el) ) nm-lst)))
	  
	  (if (or (string= (first i) "Имя")
		  (string= (first i) "Name"))
	      (setf nm (second i)))
	  (if (and nm  (string= (first i) "Address"))
	      (setf addres (second i)
		    addres-lst (cons addres addres-lst)
		    nm-lst (cons nm nm-lst))))))))
