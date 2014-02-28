PYTHON=python2.7

# targets that aren't filenames
.PHONY: all clean deploy

# all: _includes/pubs.html _site/index.html _site/wacas14/index.html
# 
# _site/index.html _site/wacas14/index.html:
# 	jekyll build $(BUILDARGS)
# 
# _includes/pubs.html: bib/sampa-pubs.bib bib/publications.tmpl
# 	mkdir -p _includes
# 	$(PYTHON) bibble/bibble.py $+ > $@
# 
# BUILDARGS :=
# _site/index.html: $(wildcard *.html) _includes/pubs.html _config.yml \
# 	_layouts/default.html
# _site/wacas14/index.html: $(wildcard wacas14/*.md) _config.yml \
# 	_layouts/wacas.html
# 
# clean:
# 	$(RM) -r _site _includes/pubs.html

CSEHOST := bicycle.cs.washington.edu
deploy: BUILDARGS := --config _config.yml,_config_sandbox.yml
deploy: clean all
	jekyll build --config _config.yml,_deploy.yml
	rsync --compress --recursive --checksum --itemize-changes --delete _site/ $(CSEHOST):/cse/web/homes/bholt
