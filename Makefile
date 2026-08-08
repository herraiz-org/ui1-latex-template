# Copyright 2026 Israel Herraiz <isra@herraiz.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.

MAIN = examples/plantilla
MAIN_DIR = examples
LATEX = pdflatex
FLAGS = -interaction=nonstopmode

PROJECT_ROOT := $(shell pwd)
TEXMF_DIR ?= $(HOME)/texmf/tex/latex/ui1_template
INSTALL_BIN ?= $(HOME)/bin
INSTALL_SKILLS ?= $(HOME)/.claude/skills
INSTALL_GEMINI_SKILLS ?= $(HOME)/.gemini/skills
INSTALL_AGENT_SKILLS ?= $(HOME)/.agents/skills
SKILL_COMPAT_DIRS ?= $(INSTALL_SKILLS) $(INSTALL_GEMINI_SKILLS) $(HOME)/.gemini/config/skills $(HOME)/.gemini/antigravity-cli/skills
ZSHRC ?= $(HOME)/.zshrc

.PHONY: all clean install uninstall open

TESTS = $(wildcard tests/latex/*.tex)
TEST_PDFS = $(patsubst tests/latex/%.tex, %.pdf, $(TESTS))

all: $(MAIN).pdf

test: $(TEST_PDFS)

$(MAIN).pdf: $(MAIN).tex imgs/portada.png imgs/interior.png
	$(LATEX) -output-directory $(MAIN_DIR) $(FLAGS) $<
	if grep -q "addbibresource" $<; then (cd $(MAIN_DIR) && biber $(notdir $(basename $<))); $(LATEX) -output-directory $(MAIN_DIR) $(FLAGS) $<; $(LATEX) -output-directory $(MAIN_DIR) $(FLAGS) $<; fi

%.pdf: tests/latex/%.tex
	$(LATEX) $(FLAGS) $<
	if grep -q "addbibresource" $<; then biber $(basename $@); $(LATEX) $(FLAGS) $<; $(LATEX) $(FLAGS) $<; fi

install:
	mkdir -p "$(TEXMF_DIR)"
	ln -sf "$(PROJECT_ROOT)/ui1activity.cls" "$(TEXMF_DIR)/ui1activity.cls"
	rm -f "$(TEXMF_DIR)/imgs"
	ln -s "$(PROJECT_ROOT)/imgs" "$(TEXMF_DIR)/imgs"
	mkdir -p "$(INSTALL_BIN)"
	cp "$(PROJECT_ROOT)/bin/new-activity" "$(INSTALL_BIN)/new-activity"
	chmod +x "$(INSTALL_BIN)/new-activity"
	@if ! grep -qF 'export PATH="$$HOME/bin:$$PATH"' "$(ZSHRC)" 2>/dev/null; then \
		echo 'export PATH="$$HOME/bin:$$PATH"' >> "$(ZSHRC)"; \
	fi
	mkdir -p "$(INSTALL_AGENT_SKILLS)/new-activity"
	cp "$(PROJECT_ROOT)/skills/new-activity/SKILL.md" "$(INSTALL_AGENT_SKILLS)/new-activity/SKILL.md"
	@canonical="$(INSTALL_AGENT_SKILLS)/new-activity"; \
	for skills_dir in $(SKILL_COMPAT_DIRS); do \
		target="$$skills_dir/new-activity"; \
		[ "$$target" = "$$canonical" ] && continue; \
		mkdir -p "$$skills_dir"; \
		if [ -L "$$target" ]; then \
			if [ "$$(readlink "$$target")" != "$$canonical" ]; then \
				echo "Error: refusing to replace skill symlink '$$target'" >&2; exit 1; \
			fi; \
			rm -f "$$target"; \
		elif [ -d "$$target" ]; then \
			entries=$$(find "$$target" -mindepth 1 -maxdepth 1 -print | wc -l); \
			if [ "$$entries" -ne 1 ] || [ ! -f "$$target/SKILL.md" ]; then \
				echo "Error: refusing to replace non-managed skill directory '$$target'" >&2; exit 1; \
			fi; \
			rm -f "$$target/SKILL.md"; rmdir "$$target"; \
		elif [ -e "$$target" ]; then \
			echo "Error: refusing to replace '$$target'" >&2; exit 1; \
		fi; \
		ln -s "$$canonical" "$$target"; \
	done

uninstall:
	rm -f "$(TEXMF_DIR)/ui1activity.cls"
	rm -f "$(TEXMF_DIR)/imgs"
	rm -f "$(INSTALL_BIN)/new-activity"
	@canonical="$(INSTALL_AGENT_SKILLS)/new-activity"; \
	for skills_dir in $(SKILL_COMPAT_DIRS); do \
		target="$$skills_dir/new-activity"; \
		[ "$$target" = "$$canonical" ] && continue; \
		if [ -L "$$target" ] && [ "$$(readlink "$$target")" = "$$canonical" ]; then \
			rm -f "$$target"; \
		elif [ -d "$$target" ] && [ -f "$$target/SKILL.md" ]; then \
			entries=$$(find "$$target" -mindepth 1 -maxdepth 1 -print | wc -l); \
			if [ "$$entries" -eq 1 ]; then \
				rm -f "$$target/SKILL.md"; rmdir "$$target"; \
			fi; \
		fi; \
	done
	rm -f "$(INSTALL_AGENT_SKILLS)/new-activity/SKILL.md"
	-rmdir "$(INSTALL_AGENT_SKILLS)/new-activity" 2>/dev/null

open: $(MAIN).pdf
	xdg-open $(MAIN).pdf

clean:
	rm -f *.aux *.log *.out *.pdf *.bbl *.bcf *.blg *.run.xml *.toc
	rm -f $(MAIN_DIR)/*.aux $(MAIN_DIR)/*.log $(MAIN_DIR)/*.out $(MAIN_DIR)/*.pdf $(MAIN_DIR)/*.bbl $(MAIN_DIR)/*.bcf $(MAIN_DIR)/*.blg $(MAIN_DIR)/*.run.xml $(MAIN_DIR)/*.toc
