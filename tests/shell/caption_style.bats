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
