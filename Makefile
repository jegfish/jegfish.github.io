# https://github.com/RagnarGrootKoerkamp/research/blob/c46e8c7840d70b86746ebe1d76384893638d8bbc/emacs/init.el

BASE_DIR := "$(shell pwd)/posts"

BUILD_CONTENT_CMD := emacs -Q --batch --load "$$PWD/makefile.el" --execute "(build/export-all)"

.PHONY: all
all: build-site

.PHONY: build-site
build-site: build-content
	hugo --destination "./docs/" --minify --cleanDestinationDir

.PHONY: build-content
build-content:
	BASE_DIR="$(shell pwd)/posts" $(BUILD_CONTENT_CMD)
	BASE_DIR="$(shell pwd)/pages" $(BUILD_CONTENT_CMD)

.PHONY: serve
serve:
	hugo server --buildDrafts

# Run this when clone the repo.
.PHONY: setup
setup:
	git submodule update --init --recursive

.PHONY: update-themes
update-themes:
	git submodule update --remote --merge
