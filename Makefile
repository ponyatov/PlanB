CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

WGET = wget -c --no-check-certificate



.PHONY: all
all: $(CWD)/bin/python3 ./$(MODULE).py
	$^



.PHONY: install
install: debian $(CWD)/bin/python3 

$(CWD)/bin/python3:
	python3 -m venv .
	$@ install -U pip

.PHONY: debian
debian:
	sudo apt install -u python3



.PHONY: merge release zip

MERGE  = Makefile README.md $(MODULE).* .gitignore doc

merge:
	git checkout master
	git checkout shadow -- $(MERGE)
	$(MAKE) doxy

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow

zip:
	git archive --format zip --output $(MODULE)_src_$(NOW)_$(REL).zip HEAD
