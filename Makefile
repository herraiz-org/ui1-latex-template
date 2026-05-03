MAIN = plantilla
LATEX = pdflatex
FLAGS = -interaction=nonstopmode

.PHONY: all clean

TESTS = $(wildcard tests/*.tex)
TEST_PDFS = $(patsubst tests/%.tex, %.pdf, $(TESTS))

all: $(MAIN).pdf

test: $(TEST_PDFS)

%.pdf: tests/%.tex
	$(LATEX) $(FLAGS) $<
	if grep -q "addbibresource" $<; then biber $(basename $@); $(LATEX) $(FLAGS) $<; $(LATEX) $(FLAGS) $<; fi

clean:
	rm -f *.aux *.log *.out *.pdf *.bbl *.bcf *.blg *.run.xml *.toc
