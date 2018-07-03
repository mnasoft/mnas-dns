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
  (list 
   (format nil "~{~A~^.~}"
	   (loop for i across
		(sb-bsd-sockets:host-ent-address
		 (sb-bsd-sockets:get-host-by-name name))
	      collect i))))



