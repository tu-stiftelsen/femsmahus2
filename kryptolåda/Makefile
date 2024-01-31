MDFILES = $(wildcard *.md)
MDFILES := $(filter-out README.md, $(MDFILES))
PDFFILES = $(MDFILES:.md=.pdf)
PANDOCOPTS = --pdf-engine=lualatex --listings

all: $(PDFFILES)

%.pdf: %.md ../template/template.tex
	pandoc $(PANDOCOPTS) --template ../template/template.tex -o $@ $<

clean:
	rm -f *.pdf
