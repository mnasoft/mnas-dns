;;;; mnas-dns.lisp

(in-package #:mnas-dns)

;;; "mnas-dns" goes here. Hacks and glory await!

(export 'ip-by-name )

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
  (handler-case
      (loop for i across
	   (sb-bsd-sockets:host-ent-address
	    (sb-bsd-sockets:get-host-by-name name))
	 collect i)

    (SB-BSD-SOCKETS:SOCKET-ERROR (condition) (values nil condition))     
    (ERROR (condition) (values nil condition))
    (:no-error (varN-1 ) (list (format nil "~{~A~^.~}" varN-1)))))

(export '*nginx-conf-dir*)

(defparameter *nginx-conf-dir* "D:/PRG/nginx-bin/conf")

(export 'nginx-by-ip-allow&deny-all )

(defun nginx-by-ip-allow&deny-all (ip-lst
				   &optional
				     (fname (concatenate 'string *nginx-conf-dir* "/" "server.blacklist")))
  "@b(Описание:) функция @b(nginx-by-ip-allow&deny-all) записывает в файл с 
именем fname разрешения на доступ к серверу, работающему под управлением nginx.

Для того, чтобы сервер воспринял это необходимо включить директиву  include
в контекст http файла nginx.conf.

 @b(Пример включения директивы include в контекст http файла nginx.conf:)
@begin[lang=nginx](code)
http {
    include       server.blacklist;
    ...
    }
@end(code)

 @b(Пример использования:)
@begin[lang=lisp](code)
 (nginx-by-ip-allow&deny-all '(\"192.168.0.100\"))
@end(code)
 "
  (with-open-file
      (os fname :direction :output :if-exists :supersede :external-format :utf8)
    (format os "~{allow ~A;~%~}~%deny all;" ip-lst)
    (format nil "См. файл ~A~%~{allow ~A;~%~}~%deny all;" fname ip-lst)))

(export 'nginx-by-compnames-allow&deny-all )

(defun nginx-by-compnames-allow&deny-all (compnames
					  &optional
					    (fname (concatenate 'string *nginx-conf-dir* "/" "server.blacklist")))
  "@b(Описание:) функция @b(nginx-by-ip-allow&deny-all) записывает в файл с 
именем fname разрешения на доступ к серверу, работающему под управлением nginx.

Для того, чтобы сервер воспринял это необходимо включить директиву  include
в контекст http файла nginx.conf.

 @b(Пример включения директивы include в контекст http файла nginx.conf:)
@begin[lang=nginx](code)
http {
    include       server.blacklist;
    ...
    }
@end(code)

 @b(Пример использования:)
@begin[lang=lisp](code)
 (nginx-by-ip-allow&deny-all '(\"n118383\"))
@end(code)
 "
  (nginx-by-ip-allow&deny-all
   (mapcan #'(lambda (el) (mnas-dns:ip-by-name el)) compnames)
   fname))
