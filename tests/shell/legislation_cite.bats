#!/usr/bin/env bats
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

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$REPO_ROOT/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$REPO_ROOT/imgs" "$TMP_DIR/imgs"
  cp "$REPO_ROOT/tests/latex/test_legislation_cite.tex" "$TMP_DIR/test.tex"
  cp "$REPO_ROOT/tests/latex/test_legislation_cite.bib" "$TMP_DIR/test_legislation_cite.bib"
  cd "$TMP_DIR"
}

teardown() {
  cd - > /dev/null
  rm -rf "$TMP_DIR"
}

compile_with_biber() {
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  biber test > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
}

@test "parencite shows short title: 'Ley de Ordenacion' without law number" {
  compile_with_biber
  run pdftotext test.pdf -
  # Before fix: citation has "Ley 16/1987...de Ordenaci" (number between Ley and description)
  # After fix:  citation has "Ley de Ordenaci" (description directly after type)
  echo "$output" | grep -q "Ley de Ordenaci"
}

@test "textcite shows short title: 'Ley de Ordenacion' without law number" {
  compile_with_biber
  run pdftotext test.pdf -
  echo "$output" | grep -q "Ley de Ordenaci"
}

@test "bibliography still shows full title with law number" {
  compile_with_biber
  run pdftotext test.pdf -
  echo "$output" | grep -q "16/1987"
}

@test "fallback: entry with no number pattern shows full title in citation" {
  cp "$REPO_ROOT/tests/latex/test_legislation_cite_fallback.tex" "$TMP_DIR/test.tex"
  cp "$REPO_ROOT/tests/latex/test_legislation_cite_fallback.bib" "$TMP_DIR/test_legislation_cite_fallback.bib"
  compile_with_biber
  run pdftotext test.pdf -
  echo "$output" | grep -q "Estatuto de los Trabajadores"
}
