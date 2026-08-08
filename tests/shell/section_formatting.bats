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

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$(pwd)/ui1activity.cls" "$TMP_DIR/ui1activity.cls"
  ln -s "$(pwd)/imgs" "$TMP_DIR/imgs"
  cp "$(pwd)/tests/latex/test_section_formatting.tex" "$TMP_DIR/test.tex"
  cd "$TMP_DIR"
}

teardown() {
  cd - > /dev/null
  rm -rf "$TMP_DIR"
}

@test "section header font size is increased" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null
  run pdflatex -interaction=nonstopmode test.tex
  [ "$status" -eq 0 ]
  
  SECTIONSZ=$(echo "$output" | grep "SECTIONSZ:" | cut -d' ' -f2)
  echo "Detected SECTIONSZ: $SECTIONSZ"
  
  # Current is 10. We expect it to be > 10 (e.g., 12 for \large or 14.4 for \Large)
  IS_GREATER=$(awk -v n1="$SECTIONSZ" -v n2="10" 'BEGIN {print (n1 > n2) ? 1 : 0}')
  [ "$IS_GREATER" -eq 1 ]
}

@test "section header spacing is reduced" {
  pdflatex -interaction=nonstopmode test.tex > /dev/null
  run pdflatex -interaction=nonstopmode test.tex
  [ "$status" -eq 0 ]
  
  SECTIONSPACING=$(echo "$output" | grep "SECTIONSPACING:" | cut -d' ' -f2)
  echo "Detected SECTIONSPACING: $SECTIONSPACING"
  
  # Current is 943716. We expect it to be less.
  [ "$SECTIONSPACING" -lt 943716 ]
}
