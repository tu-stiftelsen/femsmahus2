MDFILES = $(wildcard *.md)
MDFILES := $(filter-out README.md, $(MDFILES))
PDFFILES = $(MDFILES:.md=.pdf)
SVGFILES = $(wildcard *.svg)
PANDOCOPTS = --pdf-engine=lualatex --listings

all: $(PDFFILES)

%.svg: %.mmd
	mmdc -i $< -o $@ -t dark -b transparent

%.pdf: %.md ../template/template.tex $(SVGFILES)
	pandoc $(PANDOCOPTS) --template ../template/template.tex -o $@ $<

clean:
	rm -f *.pdf
