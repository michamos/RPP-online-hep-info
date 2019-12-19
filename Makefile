# $Id: Makefile 26321 2019-11-14 20:50:36Z anderson $
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
	pdflatex '\def\isbooklet{1} \input{$(BASENAME).tex}'
#	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex '\def\isbooklet{1} \input{$(BASENAME).tex}'
	pdflatex '\def\isbooklet{1} \input{$(BASENAME).tex}'

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
	@echo rm -vf $(BASENAME)\*.aux \*.dvi \*.lof \*.log \*.toc \*.out \*.bbl \*.blg \*.idx \*.ilg \*.ind
	@rm -vf $(BASENAME)*.aux $(BASENAME)*.dvi $(BASENAME)*.lof $(BASENAME)*.log $(BASENAME)*.toc $(BASENAME)*.out $(BASENAME)*.bbl $(BASENAME)*.blg $(BASENAME)*.idx $(BASENAME)*.ilg $(BASENAME)*.ind 

$(BASENAME)-full.aux:
	$(MAKE) nohyperref
	@mv $(BASENAME).aux $(BASENAME)-full.aux

crossref:
	$(shell grep -h '^\\newlabel' $(XREFAUX)  >crossref.aux)
	$(shell awk  'BEGIN{FS=OFS="}{"} {print $$1"}{"$$2"}{"$$3"}{REMOVED}{REMOVED}}"}' crossref.aux >crossref.tmp && mv crossref.tmp crossref.aux)




