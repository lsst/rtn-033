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

# Do the Google docs download:
$(DOCNAME).pdf:
	apt-get update
	apt-get -y install curl
	curl -L "https://docs.google.com/document/d/18_4_-oH6Xv6x7bo6rtn5FkZYaisswMnP0Oa9GvHT9WA/export?format=pdf" -o $(DOCNAME).pdf


.PHONY: clean
clean:
	latexmk -c
	rm -f $(DOCNAME).{bbl,glsdefs,pdf}
	rm -f meta.tex

.FORCE:

# We probably still do want to update the meta.tex file, in case LSSTthedocs needs it.
meta.tex: Makefile .FORCE
	rm -f $@
	touch $@
	printf '%% GENERATED FILE -- edit this in the Makefile\n' >>$@
	printf '\\newcommand{\\lsstDocType}{$(DOCTYPE)}\n' >>$@
	printf '\\newcommand{\\lsstDocNum}{$(DOCNUMBER)}\n' >>$@
	printf '\\newcommand{\\vcsRevision}{$(GITVERSION)$(GITDIRTY)}\n' >>$@
	printf '\\newcommand{\\vcsDate}{$(GITDATE)}\n' >>$@
