MDFILES = $(wildcard *.md)
MDFILES := $(filter-out README.md, $(MDFILES))
PDFFILES = $(MDFILES:.md=.pdf)
IMAGEFILES = $(wildcard *.mmd)
SVGFILES = $(IMAGEFILES:.mmd=.svg)
PNGFILES = $(IMAGEFILES:.mmd=.png)
PANDOCOPTS = --pdf-engine=lualatex --listings

all: $(PDFFILES)

figures: $(SVGFILES)

%.svg: %.mmd
	mmdc -i $< -o $@ -t dark -b transparent

%.png: %.mmd
	mmdc -i $< -o $@ -t dark -b transparent

%.pdf: %.md ../template/template.tex $(SVGFILES) $(PNGFILES)
	pandoc $(PANDOCOPTS) --template ../template/template.tex -o $@ $<

clean:
	rm -f *.pdf *.svg *.png
