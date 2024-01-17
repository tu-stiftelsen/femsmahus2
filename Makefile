MDFILES = $(wildcard */*.md)
MDFILES := $(filter-out README.md, $(MDFILES))
DIRS = $(wildcard */)
PDFFILES = $(MDFILES:.md=.pdf)
PANDOCOPTS = --pdf-engine=lualatex

all: $(PDFFILES)
	make -C internetspecifikation all

clean:
	rm -f *.pdf