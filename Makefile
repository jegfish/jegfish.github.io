TEMPLATE = template.html.p

.PHONY: all
all: docs/CNAME docs/index.html docs/styles.css docs/blog/index.html docs/blog/snailcheck-lazy.html docs/blog/snailcheck-enum.html

.PHONY: serve
serve:
	python3 -m http.server -d docs 8000

pages: racket render-page.rkt

docs/CNAME:
	mkdir -p docs
# Restore CNAME file that is destroyed by Hugo. It is necessary for
# GitHub Pages to work.
	[ -f 'docs/CNAME' ] || echo -n 'jeffreyfisher.net' > docs/CNAME

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
