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

@test "title slide shows title, subtitle, asignatura, author and date" {
  run compile_fixture test_beamer_title
  [ "$status" -eq 0 ]
  pdftotext test.pdf test.txt
  grep -q "Titulo de la presentacion" test.txt
  grep -q "Subtitulo de prueba" test.txt
  grep -q "Matematicas Financieras" test.txt
  grep -q "Israel Herraiz" test.txt
  grep -q "9 de agosto de 2026" test.txt
}

@test "title slide draws the UI1 logo" {
  compile_fixture test_beamer_title
  run pdfimages -list test.pdf
  [ "$status" -eq 0 ]
  # At least one image XObject is placed on the title slide.
  [ "$(echo "$output" | grep -c "image")" -ge 1 ]
}

@test "the logo is drawn without horizontal or vertical distortion" {
  compile_fixture test_beamer_title
  # pdfimages reports the effective resolution of each placed image; equal
  # x-ppi and y-ppi mean the image was scaled uniformly.
  run bash -c "pdfimages -list test.pdf | awk '/image/ {print \$13, \$14}'"
  [ "$status" -eq 0 ]
  [ -n "$output" ]
  while read -r xppi yppi; do
    [ -n "$xppi" ]
    # Allow one ppi of rounding slack in poppler's report.
    diff=$(awk -v a="$xppi" -v b="$yppi" 'BEGIN {d = a - b; print (d < 0 ? -d : d)}')
    [ "$(awk -v d="$diff" 'BEGIN {print (d <= 1) ? 1 : 0}')" -eq 1 ]
  done <<< "$output"
}
