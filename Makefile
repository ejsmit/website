
SHELL=/bin/bash

HUGO := hugo
NPM := yarn
NBCONVERT := jupyter nbconvert

STATIC_DIR := static/
ASSETS_JS_DIR := assets/js/vendor/
ASSETS_SCSS_DIR := assets/sass/vendor/

IPYNB = $(shell find content/ -name '*.ipynb' -print)
IPYNB2MD = $(IPYNB:%.ipynb=%.md)


COM_COLOR   = $(shell tput setaf 33)
#OBJ_COLOR   = \033[0;36m
OK_COLOR    = $(shell tput setaf 64)
ERROR_COLOR = $(shell tput setaf 128)
WARN_COLOR  = $(shell tput setaf 136)
NO_COLOR    = $(shell tput sgr0)

.PHONY = clean install

help: 
	@echo "$(WARN_COLOR)"
	@echo "Website Makefile"
	@echo "----------------"
	@echo "$(NO_COLOR)"
	@echo "$(OK_COLOR)modules  $(NO_COLOR)- install node modules and web assets"
	@echo "$(OK_COLOR)build    $(NO_COLOR)- generate Prod website"
	@echo "$(OK_COLOR)serve    $(NO_COLOR)- generate Dev website and serve using local web server"
	@echo "$(OK_COLOR)clean    $(NO_COLOR)- delete generated webite"
	@echo "$(OK_COLOR)allclean $(NO_COLOR)- delete all generated files (excl node modules)"
	@echo "$(OK_COLOR)publish  $(NO_COLOR)- deploy site to github pages"
	@echo ""
	@echo "node_modules only installed if it does not exist.  Updates are completely" 
	@echo "manual using yarn.  use '$(OK_COLOR)make allclean$(NO_COLOR)' after updating modules."
	@echo ""

clean:
	rm -Rf public

allclean: 
	rm -Rf public
	rm -Rf resources
	rm -Rf $(ASSETS_SCSS_DIR)
	rm -Rf $(ASSETS_JS_DIR)
	rm -Rf $(STATIC_DIR)/webfonts
	rm -f  $(IPYNB2MD)

modules:  node_modules resources/_gen

node_modules: package.json
	$(NPM) install
	$(NPM) install -g postcss-cli
	$(NPM) install -g autoprefixer

resources/_gen:  node_modules 
	mkdir -p $(ASSETS_SCSS_DIR)/fontawesome
	mkdir -p $(ASSETS_SCSS_DIR)/bootstrap/
	mkdir -p $(STATIC_DIR)/webfonts
	mkdir -p $(ASSETS_JS_DIR)
	cp -r node_modules/@fortawesome/fontawesome-free/webfonts $(STATIC_DIR)
	cp -r node_modules/bootstrap/scss/* $(ASSETS_SCSS_DIR)/bootstrap/
	cp node_modules/@fortawesome/fontawesome-free/scss/* $(ASSETS_SCSS_DIR)/fontawesome
	cp node_modules/jquery/dist/jquery.min.js $(ASSETS_JS_DIR)
	cp node_modules/popper.js/dist/umd/popper.min.js $(ASSETS_JS_DIR)
	cp node_modules/bootstrap/dist/js/bootstrap.min.js $(ASSETS_JS_DIR)
	# the output of this is irrelevant.   we just want the resources generated.
	$(HUGO)

build:  modules clean ipynb
	$(HUGO)

serve:  modules clean ipynb
	$(HUGO) server -D

publish: build
	@[ `git status -s | wc -l` ] && \
		echo "$(ERROR_COLOR)------------------------------------------------------------------" && \
		echo "The working directory is dirty. Please commit any pending changes." && \
		echo "------------------------------------------------------------------$(NO_COLOR)" && /bin/false
	@echo "Deleting old publication"
	rm -rf public
	mkdir public
	git worktree prune
	rm -rf .git/worktrees/public/
	@echo "Checking out gh-pages branch into public"
	git worktree add -B gh-pages public upstream/gh-pages
	@echo "Removing existing files"
	rm -rf public/*
	@echo "Generating site"
	$(HUGO)
	@echo "Updating gh-pages branch"
	cd public && git add --all && git commit -m "Publishing to gh-pages (make publish)"


ipynb:
	@# activate environment in subshell and rerun make with ipynb_sub target only.
	source $(shell conda info --base)/etc/profile.d/conda.sh && conda activate website && $(MAKE) ipynb_sub 

ipynb_sub: $(IPYNB2MD)

%.md: %.ipynb
	$(NBCONVERT) --to markdown $^
