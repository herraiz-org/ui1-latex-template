#!/usr/bin/env bats

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$(pwd)/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$(pwd)/imgs" "$TMP_DIR/imgs"
  cp "$(pwd)/tests/latex/test_caption_style.tex" "$TMP_DIR/test.tex"
  cd "$TMP_DIR"
}

teardown() {
  cd - > /dev/null
  rm -rf "$TMP_DIR"
}

@test "caption fixture compiles without errors" {
  run pdflatex -interaction=nonstopmode test.tex
  [ "$status" -eq 0 ]
}

@test "caption fixture produces PDF output" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null
  [ -f test.pdf ]
}

@test "caption font size is smaller than body text" {
  run pdflatex -interaction=nonstopmode test.tex
  [ "$status" -eq 0 ]

  NORMALSZ=$(echo "$output" | grep "NORMALSZ:" | head -1 | cut -d' ' -f2)
  CAPTIONSZ=$(echo "$output" | grep "CAPTIONSZ:" | head -1 | cut -d' ' -f2)
  echo "NORMALSZ=$NORMALSZ CAPTIONSZ=$CAPTIONSZ"

  IS_SMALLER=$(awk -v cap="$CAPTIONSZ" -v body="$NORMALSZ" 'BEGIN {print (cap < body) ? 1 : 0}')
  [ "$IS_SMALLER" -eq 1 ]
}
