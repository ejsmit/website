
SHELL=/bin/bash

HUGO := hugo
NBCONVERT := jupyter nbconvert

PUBLIC_DIR := docs/

IPYNB = $(shell find content/ -name '*.ipynb' -print)
IPYNB2MD = $(IPYNB:%.ipynb=%.md)


COM_COLOR   = $(shell tput setaf 33)
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
	@echo "$(OK_COLOR)build    $(NO_COLOR)- generate Prod website"
	@echo "$(OK_COLOR)serve    $(NO_COLOR)- generate Dev website and serve using local web server"
	@echo "$(OK_COLOR)preview  $(NO_COLOR)- generate Prod website and serve using local web server"
	@echo "$(OK_COLOR)clean    $(NO_COLOR)- delete generated webite"
	@echo "$(OK_COLOR)allclean $(NO_COLOR)- delete all generated files"
	@echo ""

clean:
	rm -Rf $(PUBLIC_DIR)

allclean:
	rm -Rf $(PUBLIC_DIR)
	rm -f  $(IPYNB2MD)

build:  clean ipynb
	$(HUGO)

serve:  clean ipynb
	$(HUGO) server -D

preview:  clean ipynb
	$(HUGO) server

ipynb:
	@# activate environment in subshell and rerun make with ipynb_sub target only.
	source $(shell conda info --base)/etc/profile.d/conda.sh && conda activate website && $(MAKE) ipynb_sub

ipynb_sub: $(IPYNB2MD)

%.md: %.ipynb
	$(NBCONVERT) --to markdown $^
