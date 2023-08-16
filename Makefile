MDFILES = $(wildcard *.md)
MDFILES := $(filter-out README.md, $(MDFILES))
PDFFILES = $(MDFILES:.md=.pdf)

all: $(PDFFILES)

clean:
	rm -f *.pdf

%.pdf: %.md template/template.tex
	pandoc --template template/template.tex -o $@ $<
