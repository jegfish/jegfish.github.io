◊(require pollen/decode racket/format)
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <link rel="stylesheet" type="text/css" media="all" href="/styles.css" />
    <title>◊(select 'h1 doc)</title>
  </head>
<body>
<header>
  <nav aria-labelledby="primary-navigation">
    <ol>
      <li><a href="/">Home</a></li>
      <li><a href="/blog">Blog</a></li>
      <li><a href="/">Projects</a></li>
    </ol>
  </nav>
</header>

<!--
◊;(~v doc)
◊;(~v (->html (decode-paragraphs doc)))
-->
◊(->html (decode-paragraphs (cdr (merge-newlines doc)) #:linebreak-proc (λ (x) x)) #:splice? #t)
</body>
</html>
