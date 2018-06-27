;;;; mnas-dns.asd

(asdf:defsystem #:mnas-dns
  :description "Describe mnas-dns here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t
  :depends-on (#:cl-ppcre #:sb-bsd-sockets)
  :components ((:file "package")
               (:file "mnas-dns")))




