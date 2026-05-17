#!/usr/bin/env bats

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$REPO_ROOT/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$REPO_ROOT/imgs" "$TMP_DIR/imgs"
  cp "$REPO_ROOT/tests/latex/test_normal_citation.tex" "$TMP_DIR/test.tex"
  cp "$REPO_ROOT/tests/latex/test_normal_citation.bib" "$TMP_DIR/test_normal_citation.bib"
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

@test "test_normal_citation.tex compiles without errors" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  biber test > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  run pdflatex -interaction=nonstopmode test.tex
  [ "$status" -eq 0 ]
}

@test "first in-text citation includes author surname in parentheses" {
  compile_with_biber
  run pdftotext test.pdf -
  echo "$output" | grep -q "(García"
}

@test "second in-text citation to same author also includes author surname" {
  compile_with_biber
  run pdftotext test.pdf -
  # Count occurrences of the author in parenthesized context
  COUNT=$(echo "$output" | grep -o "(García" | wc -l)
  [ "$COUNT" -ge 2 ]
}

@test "in-text citation includes year" {
  compile_with_biber
  run pdftotext test.pdf -
  echo "$output" | grep -q "2021"
}

@test "no empty-bibliography warnings in log" {
  compile_with_biber
  run grep -ic "empty bibliography" test.log
  [ "$output" -eq 0 ]
}
