MDFILES = $(wildcard *.md)
MDFILES := $(filter-out README.md, $(MDFILES))
PDFFILES = $(MDFILES:.md=.pdf)
PANDOCOPTS = --pdf-engine=lualatex

all: $(PDFFILES)

clean:
	rm -f *.pdf

%.pdf: %.md template/template.tex
	pandoc $(PANDOCOPTS) --template template/template.tex -o $@ $<
