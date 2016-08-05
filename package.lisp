;;;; package.lisp

(defpackage #:mnas-dns
  (:use #:cl #:cl-ppcre)
  (:export ip-by-name))

;;;;(declaim (optimize (space 0) (compilation-speed 0)  (speed 0) (safety 3) (debug 3)))
