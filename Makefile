# $Id: Makefile 28199 2020-10-19 18:03:00Z anderson $
# Template for general Makefile for LaTeX-based reviews

BASENAME := databases
SUBREVS := nonaccel pardet hadronic
ALLSUBREVS := $(foreach SUBREV, $(SUBREVS), $(shell find .. -mindepth 1 -maxdepth 1 -type d -name '$(SUBREV)-*' -printf "%f "))
ALLREVS := $(shell find .. -mindepth 1 -maxdepth 1 -type d -printf "%f ")
ALLREVSX := $(filter-out $(BASENAME),$(ALLREVS))
ALLREVSX := $(filter-out $(ALLSUBREVS), $(ALLREVSX))
XREFAUX := $(foreach AUX, $(ALLREVSX), ../$(AUX)/$(AUX).aux) 


draft:
	pdflatex '\def\isdraft{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex '\def\isdraft{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	makeindex $(BASENAME).idx
	pdflatex '\def\isdraft{1} \input{$(BASENAME).tex}'
	pdflatex '\def\isdraft{1} \input{$(BASENAME).tex}'


book:
	pdflatex '\def\isbook{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex '\def\isbook{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex '\def\isbook{1} \input{$(BASENAME).tex}'
	pdflatex '\def\isbook{1} \input{$(BASENAME).tex}'


web:
	pdflatex "\def\isweb{1} \input{$(BASENAME).tex}"
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex "\def\isweb{1} \input{$(BASENAME).tex}"
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex "\def\isweb{1} \input{$(BASENAME).tex}"
	pdflatex "\def\isweb{1} \input{$(BASENAME).tex}"



booklet:	$(BASENAME)-full.aux
	pdflatex  -jobname=$(BASENAME)-booklet '\def\isbooklet{1} \input{$(BASENAME).tex}'
#	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex  -jobname=$(BASENAME)-booklet '\def\isbooklet{1} \input{$(BASENAME).tex}'
	pdflatex  -jobname=$(BASENAME)-booklet '\def\isbooklet{1} \input{$(BASENAME).tex}'

once:
	pdflatex '\def\isdraft{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi

webonce:
	pdflatex '\def\isweb{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi

bookonce:
	pdflatex '\def\isbook{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi

nohyperref:
	pdflatex "\def\nohyperref{1} \input{$(BASENAME).tex}"
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex "\def\nohyperref{1} \input{$(BASENAME).tex}"
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex "\def\nohyperref{1} \input{$(BASENAME).tex}"
	pdflatex "\def\nohyperref{1} \input{$(BASENAME).tex}"


prod:
	$(MAKE) clean
	$(MAKE) web

bib:	
	bibtex $(BASENAME).1

mergedbib:
	bibtool --preserve.key.case=on --preserve.keys=on -o $(BASENAME).bib -d -s ../$(BASENAME)-*/*.bib

clean:
	@echo rm -vf $(BASENAME)\*.aux \*.dvi \*.lof \*.log \*.toc \*.out \*.bbl \*.blg \*.idx \*.ilg \*.ind \*.tmb
	@rm -vf $(BASENAME)*.aux $(BASENAME)*.dvi $(BASENAME)*.lof $(BASENAME)*.log $(BASENAME)*.toc $(BASENAME)*.out $(BASENAME)*.bbl $(BASENAME)*.blg $(BASENAME)*.idx $(BASENAME)*.ilg $(BASENAME)*.ind $(BASENAME)*.tmb

$(BASENAME)-full.aux:
	$(MAKE)
	@mv $(BASENAME).aux $(BASENAME)-full.aux

crossref:
	$(shell grep -h '^\\newlabel' $(XREFAUX)  >crossref.aux)



# Auxiliary review-specific Makefile
-include Makefile.$(BASENAME)
