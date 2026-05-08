#!/usr/bin/env bats

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$(pwd)/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$(pwd)/imgs" "$TMP_DIR/imgs"
  cp "$(pwd)/tests/latex/test_bib_spacing.tex" "$TMP_DIR/test.tex"
  cd "$TMP_DIR"
}

teardown() {
  cd - > /dev/null
  rm -rf "$TMP_DIR"
}

@test "bibliography spacing matches paragraph spacing" {
  run pdflatex -interaction=nonstopmode test.tex
  [ "$status" -eq 0 ]
  
  BIBSPACING=$(echo "$output" | grep "BIBSPACING:" | cut -d' ' -f2)
  PARSKIP=$(echo "$output" | grep "PARSKIP:" | cut -d' ' -f2)
  
  echo "Detected BIBSPACING: $BIBSPACING"
  echo "Detected PARSKIP: $PARSKIP"
  
  [ "$BIBSPACING" = "$PARSKIP" ]
}
