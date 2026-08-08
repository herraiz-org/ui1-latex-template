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
