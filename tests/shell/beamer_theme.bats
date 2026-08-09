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

PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

setup() {
  TMP_DIR=$(mktemp -d)
  ln -s "$PROJECT_ROOT/beamerthemeui1beamer.sty" "$TMP_DIR/beamerthemeui1beamer.sty"
  ln -s "$PROJECT_ROOT/imgs" "$TMP_DIR/imgs"
  cd "$TMP_DIR"
}

teardown() {
  cd - > /dev/null
  rm -rf "$TMP_DIR"
}

# Compile a fixture from tests/latex/ inside the temporary directory.
compile_fixture() {
  cp "$PROJECT_ROOT/tests/latex/$1.tex" "$TMP_DIR/test.tex"
  pdflatex -interaction=nonstopmode -halt-on-error test.tex > compile.log 2>&1
}

@test "theme loads with \\usetheme{ui1beamer} and compiles" {
  run compile_fixture test_beamer_loads
  [ "$status" -eq 0 ]
  [ -f test.pdf ]
}

@test "slides are 16:9 (160mm x 90mm)" {
  compile_fixture test_beamer_loads
  run pdfinfo test.pdf
  [ "$status" -eq 0 ]
  # 160mm x 90mm = 453.54 x 255.12 bp, reported by pdfinfo as "Page size"
  echo "$output" | grep -E "Page size: *45[34](\.[0-9]+)? x 25[45](\.[0-9]+)? pts"
}
