#lang racket
(require pollen/render)

(define cli
  (command-line
   #:args (filename template output-file)
   (list filename template output-file)))

(match cli
  [(list file-to-compile template output-file)
   (render-to-file (path->complete-path file-to-compile)
                   (path->complete-path template)
                   (path->complete-path output-file))]
  )
