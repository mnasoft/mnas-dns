;;;; mnas-dns.lisp

(in-package #:mnas-dns)
(annot:enable-annot-syntax)

;;; "mnas-dns" goes here. Hacks and glory await!

@export
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

@export
(defparameter *nginx-conf-dir* "D:/PRG/nginx-bin/conf")

@export
@annot.doc:doc
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
(defun nginx-by-ip-allow&deny-all
    (ip-lst
     &optional
       (fname (concatenate 'string *nginx-conf-dir* "/" "server.blacklist")))
  (with-open-file
      (os fname :direction :output :if-exists :supersede :external-format :utf8)
    (format os "~{allow ~A;~%~}~%deny all;" ip-lst)
    (format nil "См. файл ~A~%~{allow ~A;~%~}~%deny all;" fname ip-lst)))

@export
@annot.doc:doc
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
(defun nginx-by-compnames-allow&deny-all
    (compnames
     &optional
       (fname (concatenate 'string *nginx-conf-dir* "/" "server.blacklist")))
  (nginx-by-ip-allow&deny-all
   (mapcan #'(lambda (el) (mnas-dns:ip-by-name el)) compnames)
   fname))
