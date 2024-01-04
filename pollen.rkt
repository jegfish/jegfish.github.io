#lang racket
(require txexpr pollen/setup pollen/decode)
(provide (all-defined-out))

(module setup racket/base
  (provide (all-defined-out))
  (define poly-targets '(html tex pdf)))

(define default-css (file->string "/home/jeff/jeffrey-fisher-files/dev/all/website/styles.css"))

(define (todo . elements)
  (case (current-poly-target)
    [else ""]))

(define (h2 . elements)
  (case (current-poly-target)
    [(tex pdf) (apply string-append `("{\\huge " ,@elements "}"))]
    [(txt) (map string-upcase elements)]
    [(html) (txexpr 'h2 empty elements)]
    [else (txexpr 'h2 empty elements)]
    ))

(define (codeblock #:lang [lang '()] . elements)
  `(pre (code ,@elements)))

(define (title . elements)
  (case (current-poly-target)
    [(html) (txexpr 'h1 empty elements)]
    ))

(define (footnote . elements)
  (case (current-poly-target)
    [(html) (txexpr 'sup empty (map ~v elements))]
    ))

(define (hyperlink url . elements)
  (case (current-poly-target)
    [(html) (txexpr 'a `((href ,url)) elements)]
    ))

(define (url . elements)
  (case (current-poly-target)
    [(html) (txexpr 'a `((href ,@elements)) elements)]
    ))

(define (stdin #:lang (lang '()) . elements)
  (case (current-poly-target)
    [(html) `(pre (code ,@elements))]
    ))

(define (stderr . elements)
  (case (current-poly-target)
    [(html) `(pre (code ,@elements))]
    ))

(define (enumerate . elements)
  (case (current-poly-target)
    [(html) (txexpr 'ul empty elements)]
    ))

(define (item . elements)
  (case (current-poly-target)
    [(html) (txexpr 'li empty elements)]
    ))

(define (def-footnote id . elements)
  (case (current-poly-target)
    [(html) (txexpr 'p empty elements)]
    ))
