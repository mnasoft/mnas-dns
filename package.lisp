;;;; package.lisp

(defpackage :mnas-dns
  (:use #:cl #:cl-ppcre)
  (:export ip-by-name))

(in-package :mnas-dns)
  

;;;;(declaim (optimize (space 0) (compilation-speed 0)  (speed 0) (safety 3) (debug 3)))

;;;; (declaim (optimize (compilation-speed 0) (debug 3) (safety 0) (space 0) (speed 0)))
