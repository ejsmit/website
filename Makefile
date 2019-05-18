
HUGO := hugo
NPM := npm
STATIC_DIR := static/
ASSETS_JS_DIR := assets/js/vendor/
ASSETS_SCSS_DIR := assets/sass/vendor/

files: 


build:
	rm -fr resources/
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
	cp node_modules/lunr/lunr.min.js $(ASSETS_JS_DIR)
	HUGO_ENV=production $(HUGO)

serve: clean build
	$(HUGO) server --source=exampleSite --themesDir=../..
	rm -fr resources/
	mv exampleSite/resources/ .
serve-github-docs: clean build
	$(HUGO) server --source=exampleSite --themesDir=../.. --config=../config-github-docs.toml
	rm -fr resources/
	mv exampleSite/resources/ .

######################

update: update-npm build
install-npm:
	$(NPM) install
	npm install -g postcss-cli #needs to install globally 
	npm install -g autoprefixer
update-npm:
	$(NPM) update

generate-githubpages: build
	rm -fr docs && HUGO_ENV=production $(HUGO) --source=exampleSite --themesDir=../.. --config=../config-github-docs.toml && mv exampleSite/public docs && touch docs/.nojekyll

clean:
	find . -name "*~" -exec rm {} -v \;
	find . -name "*#" -exec rm {} -v \;

