TEMPLATE = template.html.p

.PHONY: all
all: docs/index.html docs/styles.css docs/blog/index.html docs/blog/snailcheck-lazy.html docs/blog/snailcheck-enum.html

pages: racket render-page.rkt

docs/index.html: index.poly.pm
	racket render-page.rkt $< $(TEMPLATE) $@

docs/styles.css: styles.css
	cp $< $@

docs/blog/index.html: blog/index.poly.pm
	racket render-page.rkt $< $(TEMPLATE) $@

docs/blog/snailcheck-lazy.html: blog/snailcheck-lazy.poly.pm
	racket render-page.rkt $< $(TEMPLATE) $@

docs/blog/snailcheck-enum.html: blog/snailcheck-enum.poly.pm
	racket render-page.rkt $< $(TEMPLATE) $@
