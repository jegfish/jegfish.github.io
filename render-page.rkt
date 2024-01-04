#lang racket
(require pollen/render)

(define file-to-compile
  (command-line
   #:args (filename)
   filename))

(render-to-file file-to-compile)
