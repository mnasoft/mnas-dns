;;;; mnas-dns.asd

(defsystem #:mnas-dns
  :description "Describe mnas-dns here"
  :author "Mykola Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"  
  :serial t
  :depends-on (#:cl-ppcre #:sb-bsd-sockets)
  :components ((:file "package")
               (:file "mnas-dns")))




