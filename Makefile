TEMPLATE = src/template.html.p

.PHONY: all
all: docs/CNAME docs/index.html docs/styles.css docs/blog/index.html docs/blog/snailcheck-lazy.html docs/blog/snailcheck-enum.html

# Serve the built pages, for testing that the building went okay.
.PHONY: serve
serve:
	python3 -m http.server -d docs 8000

# Serving pages during development, for quick reloading.
.PHONY: dev
dev:
	raco pollen start src

docs/CNAME:
	mkdir -p docs
# Restore CNAME file that is destroyed by Hugo. It is necessary for
# GitHub Pages to work.
	[ -f 'docs/CNAME' ] || echo -n 'jeffreyfisher.net' > docs/CNAME

docs/index.html: src/index.poly.pm
	racket render-page.rkt $< $(TEMPLATE) $@

docs/styles.css: src/styles.css
	cp $< $@

docs/blog/index.html: src/blog/index.poly.pm
	racket render-page.rkt $< $(TEMPLATE) $@

docs/blog/snailcheck-lazy.html: src/blog/snailcheck-lazy.poly.pm
	racket render-page.rkt $< $(TEMPLATE) $@

docs/blog/snailcheck-enum.html: src/blog/snailcheck-enum.poly.pm
	racket render-page.rkt $< $(TEMPLATE) $@
