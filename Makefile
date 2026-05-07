MAIN = plantilla
LATEX = pdflatex
FLAGS = -interaction=nonstopmode

PROJECT_ROOT := $(shell pwd)
TEXMF_DIR ?= $(HOME)/texmf/tex/latex/ui1_template

.PHONY: all clean install uninstall

TESTS = $(wildcard tests/*.tex)
TEST_PDFS = $(patsubst tests/%.tex, %.pdf, $(TESTS))

all: $(MAIN).pdf

test: $(TEST_PDFS)

$(MAIN).pdf: $(MAIN).tex imgs/portada.png imgs/interior.png
	$(LATEX) $(FLAGS) $<
	if grep -q "addbibresource" $<; then biber $(basename $@); $(LATEX) $(FLAGS) $<; $(LATEX) $(FLAGS) $<; fi

%.pdf: tests/%.tex
	$(LATEX) $(FLAGS) $<
	if grep -q "addbibresource" $<; then biber $(basename $@); $(LATEX) $(FLAGS) $<; $(LATEX) $(FLAGS) $<; fi

install:
	mkdir -p "$(TEXMF_DIR)"
	ln -sf "$(PROJECT_ROOT)/ui1activity.cls" "$(TEXMF_DIR)/ui1activity.cls"
	ln -sf "$(PROJECT_ROOT)/imgs" "$(TEXMF_DIR)/imgs"

uninstall:
	rm -f "$(TEXMF_DIR)/ui1activity.cls"
	rm -f "$(TEXMF_DIR)/imgs"

clean:
	rm -f *.aux *.log *.out *.pdf *.bbl *.bcf *.blg *.run.xml *.toc
