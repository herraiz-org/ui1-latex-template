#!/usr/bin/env bats

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$(pwd)/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$(pwd)/imgs" "$TMP_DIR/imgs"
  cp "$(pwd)/tests/latex/test_pdf_metadata.tex" "$TMP_DIR/test.tex"
  cd "$TMP_DIR"
}

teardown() {
  cd - > /dev/null
  rm -rf "$TMP_DIR"
}

@test "PDF metadata: Title is set from unidaddidactica" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdfinfo test.pdf | grep -q "^Title:.*Test Activity Title"
}

@test "PDF metadata: Author is set from alumno" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdfinfo test.pdf | grep -q "^Author:.*Test Alumno"
}

@test "PDF metadata: Subject is set from asignatura" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdfinfo test.pdf | grep -q "^Subject:.*Test Asignatura"
}

@test "PDF contains bookmark/outline data" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  pdflatex -interaction=nonstopmode test.tex > /dev/null 2>&1
  python3 -c "from pypdf import PdfReader; r=PdfReader('test.pdf'); exit(0 if len(r.outline)>0 else 1)"
}
