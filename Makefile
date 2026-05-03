MAIN = plantilla
LATEX = pdflatex
FLAGS = -interaction=nonstopmode

.PHONY: all clean

all: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex portada.png interior.png
	$(LATEX) $(FLAGS) $(MAIN).tex
	bibtex $(MAIN)
	$(LATEX) $(FLAGS) $(MAIN).tex
	$(LATEX) $(FLAGS) $(MAIN).tex

clean:
	rm -f $(MAIN).aux $(MAIN).log $(MAIN).out $(MAIN).pdf $(MAIN).bbl $(MAIN).bcf $(MAIN).blg $(MAIN).run.xml
