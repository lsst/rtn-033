DOCTYPE = RTN
DOCNUMBER = 033
DOCNAME = $(DOCTYPE)-$(DOCNUMBER)

# This Makefile does not do anything with latex or tex files - instead, it downloads a PDF from Google docs. 

# tex = $(filter-out $(wildcard *acronyms.tex) , $(wildcard *.tex))

GITVERSION := $(shell git log -1 --date=short --pretty=%h)
GITDATE := $(shell git log -1 --date=short --pretty=%ad)
GITSTATUS := $(shell git status --porcelain)
ifneq "$(GITSTATUS)" ""
	GITDIRTY = -dirty
endif

# export TEXMFHOME ?= lsst-texmf/texmf

# Add aglossary.tex as a dependancy here if you want a glossary (and remove acronyms.tex)
# $(DOCNAME).pdf: $(tex) meta.tex local.bib acronyms.tex
# 	latexmk -bibtex -xelatex -f $(DOCNAME)
#	makeglossaries $(DOCNAME)
#	xelatex $(SRC)
# For glossary uncomment the 2 lines above

# Acronym tool allows for selection of acronyms based on tags - you may want more than DM
# acronyms.tex: $(tex) myacronyms.txt
# 	$(TEXMFHOME)/../bin/generateAcronyms.py -t "DM" $(tex)

# If you want a glossary you must manually run generateAcronyms.py  -gu to put the \gls in your files.
# aglossary.tex :$(tex) myacronyms.txt
# 	generateAcronyms.py  -g $(tex)


# Do the Google docs download. Note that we still need to make the meta.tex file, for LSSTthedocs to use.
# We also want a plain text version, for back-up - so we get this first (below), then grab the PDF:

$(DOCNAME).pdf: meta.tex $(DOCNAME).txt
	curl -L "https://docs.google.com/document/d/1QTTl50l2FCMV1EvwvURCj5ui28eZTIW27EjO1etg4lM/export?format=pdf" -o $@

.PHONY: clean
clean:
	latexmk -c
	rm -f $(DOCNAME).{bbl,glsdefs,pdf}
	rm -f meta.tex

.FORCE:

meta.tex: Makefile .FORCE
	rm -f $@
	touch $@
	printf '%% GENERATED FILE -- edit this in the Makefile\n' >>$@
	printf '\\newcommand{\\lsstDocType}{$(DOCTYPE)}\n' >>$@
	printf '\\newcommand{\\lsstDocNum}{$(DOCNUMBER)}\n' >>$@
	printf '\\newcommand{\\vcsRevision}{$(GITVERSION)$(GITDIRTY)}\n' >>$@
	printf '\\newcommand{\\vcsDate}{$(GITDATE)}\n' >>$@

# Here's where we download, as back-up in case the Google doc gets lost in future, a plain text copy of the Gdoc content, and check it in to the repo.
# Note that GitHub wants to know who is making the commit. See the discussion at https://github.community/t/how-does-one-commit-from-an-action/16127/9

$(DOCNAME).txt:
	apt-get update
	apt-get -y install curl
	curl -L "https://docs.google.com/document/d/1QTTl50l2FCMV1EvwvURCj5ui28eZTIW27EjO1etg4lM/export?format=txt" -o $@
	git config --local user.email github-actions@github.com
	git config --local user.name github-actions
	git add $@
	git commit -m 'Plain text downloaded on $(GITDATE) for Revision $(GITVERSION)$(GITDIRTY)' $@
	git push
