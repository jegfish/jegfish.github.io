#lang racket
(require txexpr pollen/core pollen/setup pollen/decode)
(provide (all-defined-out))

(module setup racket/base
  (provide (all-defined-out))
  (define poly-targets '(html tex pdf)))

(define (html/make-footnote-id id)
  (format "fn-~a" id))

;; (define default-css (file->string "/home/jeff/jeffrey-fisher-files/dev/all/website/styles.css"))

(define (todo . elements)
  (case (current-poly-target)
    [else ""]))

(define (bloglink post . elements)
  (let* ([post-path (string-append post ".html")]
         [name (if (empty? elements)
                  (list (car (select-from-doc 'h1 post-path)))
                  elements)])
    (case (current-poly-target)
      [(html) (txexpr 'a `((href ,(string-append "/blog/" post-path))) name)]
      )))

;; (define (bloglink blogpost . elements)
;;   (let ([name (if (empty? elements)
;;                   (begin (require (only-in "nailche)))
;;                   elements)])
;;     (case (current-poly-target)
;;       [(html) (txexpr 'a `((href ,url)) name)]
;;       )))

(define (h1 . elements) (error "Don't use ◊h1, use ◊title instead"))

(define (h2 . elements)
  (case (current-poly-target)
    [(tex pdf) (apply string-append `("{\\huge " ,@elements "}"))]
    [(txt) (map string-upcase elements)]
    [(html) (txexpr 'h2 empty elements)]
    [else (txexpr 'h2 empty elements)]
    ))

(define (codeblock #:lang [lang '()] . elements)
  `(pre (code ,@elements)))

(define (stdin #:lang (lang '()) . elements)
  (case (current-poly-target)
    [(html) `(pre (code ,@elements))]
    ))

(define (stdout . elements)
  (case (current-poly-target)
    [(html) `(pre (code ,@elements))]
    ))

(define (stderr . elements)
  (case (current-poly-target)
    [(html) `(pre (code ,@elements))]
    ))

(define (title . elements)
  (case (current-poly-target)
    [(html) (txexpr 'h1 empty elements)]
    ))

(define (footnote . elements)
  (case (current-poly-target)
    [(html)
     (let ([id (apply string-append (map ~v elements))])
       `(sup (a ((href ,(string-append "#" (html/make-footnote-id id)))) ,id))
       )]
    ))

(define (hyperlink url . elements)
  (case (current-poly-target)
    [(html) (txexpr 'a `((href ,url)) elements)]
    ))

(define (url . elements)
  (case (current-poly-target)
    [(html) (txexpr 'a `((href ,@elements)) elements)]
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
    [(html) `(p ((id ,(html/make-footnote-id id))) ,(~v id) ". " ,@elements)]
    ))
