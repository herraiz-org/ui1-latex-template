#!/usr/bin/env bats

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$REPO_ROOT/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$REPO_ROOT/imgs" "$TMP_DIR/imgs"
  cp "$REPO_ROOT/tests/latex/test_legislation.tex" "$TMP_DIR/test.tex"
  cp "$REPO_ROOT/tests/latex/test_legislation.bib" "$TMP_DIR/test_legislation.bib"
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

@test "ui1activity.cls declares legislation bibliography driver" {
  grep -q "DeclareBibliographyDriver{legislation}" "$REPO_ROOT/ui1activity.cls"
}

@test "test_legislation.tex compiles without errors under pdflatex and biber" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  biber test > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  run pdflatex -interaction=nonstopmode test.tex
  [ "$status" -eq 0 ]
}

@test "compiled PDF contains BOE número" {
  compile_with_biber
  pdftotext test.pdf - | grep -q "BOE"
}

@test "compiled PDF contains Legislación heading (Spanish babel active)" {
  compile_with_biber
  pdftotext test.pdf - | grep -q "Legislaci"
}

@test "English document renders heading as Legislation" {
  cp "$REPO_ROOT/tests/latex/test_legislation_english.tex" test.tex
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  biber test > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdftotext test.pdf - | grep -q "^Legislation$"
}

@test "Legislación section appears before Referencias when both are present" {
  cp "$REPO_ROOT/tests/latex/test_legislation_mixed.tex" test.tex
  cp "$REPO_ROOT/tests/latex/test_legislation_mixed.bib" test_legislation_mixed.bib
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  biber test > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  PDF_TEXT=$(pdftotext test.pdf -)
  LEG_POS=$(echo "$PDF_TEXT" | grep -n "Legislaci" | head -1 | cut -d: -f1)
  REF_POS=$(echo "$PDF_TEXT" | grep -n "Referencias" | head -1 | cut -d: -f1)
  [ -n "$LEG_POS" ]
  [ -n "$REF_POS" ]
  [ "$LEG_POS" -lt "$REF_POS" ]
}
