#!/usr/bin/env bats

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$REPO_ROOT/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$REPO_ROOT/imgs" "$TMP_DIR/imgs"
  cp "$REPO_ROOT/tests/latex/test_jurisprudencia.tex" "$TMP_DIR/test.tex"
  cp "$REPO_ROOT/tests/latex/test_jurisprudencia.bib" "$TMP_DIR/test_jurisprudencia.bib"
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

@test "ui1activity.cls declares jurisprudencia bibliography driver" {
  grep -q "DeclareBibliographyDriver{jurisprudencia}" "$REPO_ROOT/ui1activity.cls"
}

@test "test_jurisprudencia.tex compiles without errors under pdflatex and biber" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  biber test > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  run pdflatex -interaction=nonstopmode test.tex
  [ "$status" -eq 0 ]
}

@test "compiled PDF contains ECLI:" {
  compile_with_biber
  pdftotext test.pdf - | grep -q "ECLI:"
}

@test "compiled PDF contains Jurisprudencia heading" {
  compile_with_biber
  pdftotext test.pdf - | grep -q "Jurisprudencia"
}

@test "inline citation renders as (STS 751/1984)" {
  compile_with_biber
  pdftotext test.pdf - | grep -q "(STS 751/1984)"
}

@test "Jurisprudencia section appears before Legislacion in combined document" {
  cp "$REPO_ROOT/tests/latex/test_jurisprudencia_mixed.tex" test.tex
  cp "$REPO_ROOT/tests/latex/test_jurisprudencia_mixed.bib" test_jurisprudencia_mixed.bib
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  biber test > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  PDF_TEXT=$(pdftotext test.pdf -)
  JURIS_POS=$(echo "$PDF_TEXT" | grep -n "Jurisprudencia" | head -1 | cut -d: -f1)
  LEG_POS=$(echo "$PDF_TEXT" | grep -n "Legislaci" | head -1 | cut -d: -f1)
  [ -n "$JURIS_POS" ]
  [ -n "$LEG_POS" ]
  [ "$JURIS_POS" -lt "$LEG_POS" ]
}

@test "empty document emits no Jurisprudencia section" {
  cp "$REPO_ROOT/tests/latex/test_jurisprudencia_empty.tex" test.tex
  compile_with_biber
  run pdftotext test.pdf -
  echo "$output" | grep -qv "Jurisprudencia"
}
