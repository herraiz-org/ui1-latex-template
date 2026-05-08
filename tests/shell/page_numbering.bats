#!/usr/bin/env bats

setup() {
  # Create a temporary directory for compilation artifacts
  TMP_DIR=$(mktemp -d)
  # Symlink the class file and images so pdflatex can find them
  ln -s "$(pwd)/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$(pwd)/imgs" "$TMP_DIR/imgs"
  cp "$(pwd)/tests/latex/page_numbering.tex" "$TMP_DIR/test.tex"
  cd "$TMP_DIR"
}

teardown() {
  cd - > /dev/null
  rm -rf "$TMP_DIR"
}

@test "first section in TOC is recorded as page 1" {
  # Run pdflatex twice to ensure TOC is generated and populated
  pdflatex -interaction=nonstopmode test.tex > /dev/null
  pdflatex -interaction=nonstopmode test.tex > /dev/null
  
  [ -f test.toc ]
  
  # The first section entry in .toc should have {1} as the last argument
  # Typical format: \contentsline {section}{\numberline {1}Primera Secci\IeC {\'o}n}{1}{section.1}
  # We are looking for the '1' before 'section.1'
  grep -q "Primera Secci.*}{1}" test.toc
}
