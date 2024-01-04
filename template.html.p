◊(require pollen/decode racket/format)
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <!-- <link rel="stylesheet" type="text/css" media="all" href="styles.css" /> -->
    <style type="text/css">
    ◊default-css
    </style>
  </head>
<body>
<!--
◊(~v doc)
◊;(~v (->html (decode-paragraphs doc)))
-->
◊(->html (decode-paragraphs (cdr (merge-newlines doc)) #:linebreak-proc (λ (x) x)) #:splice? #t)
</body>
</html>
