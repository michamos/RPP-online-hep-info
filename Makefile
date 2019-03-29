# $Id: Makefile 23955 2019-03-27 18:12:41Z anderson $
# Template for general Makefile for LaTeX-based reviews

# Determine base name of review from containing directory
BASENAME := $(notdir $(realpath .))

draft:
	pdflatex '\def\isdraft{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	makeindex $(BASENAME).idx
	pdflatex '\def\isdraft{1} \input{$(BASENAME).tex}'
	pdflatex '\def\isdraft{1} \input{$(BASENAME).tex}'


book:
	pdflatex '\def\isbook{1} \input{$(BASENAME).tex}'
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex '\def\isbook{1} \input{$(BASENAME).tex}'
	pdflatex '\def\isbook{1} \input{$(BASENAME).tex}'


web:
	pdflatex "\def\isweb{1} \input{$(BASENAME).tex}"
	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex "\def\isweb{1} \input{$(BASENAME).tex}"
	pdflatex "\def\isweb{1} \input{$(BASENAME).tex}"


booklet:	$(BASENAME)-full.aux
	pdflatex '\def\isbooklet{1} \input{$(BASENAME).tex}'
#	if [ -s $(BASENAME).bib ]; then bibtex $(BASENAME).1 ; fi
	pdflatex '\def\isbooklet{1} \input{$(BASENAME).tex}'
	pdflatex '\def\isbooklet{1} \input{$(BASENAME).tex}'



bib:	
	bibtex $(BASENAME).1

mergedbib:
	bibtool -o $(BASENAME).bib -d -s ../$(BASENAME)-*/*.bib

clean:
	@echo rm -vf \*.aux \*.dvi \*.lof \*.log \*.toc \*.out \*.bbl \*.blg \*.idx \*.ilg \*.ind
	@rm -vf *.aux *.dvi *.lof *.log *.toc *.out *.bbl *.blg *.idx *.ilg *.ind

$(BASENAME)-full.aux:
	$(MAKE) book
	@mv $(BASENAME).aux $(BASENAME)-full.aux
