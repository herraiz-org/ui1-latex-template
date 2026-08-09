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

# Print the RGB value of one pixel of a rendered page: page_pixel PAGE X Y,
# with X and Y as fractions of the page measured from the top-left corner.
page_pixel() {
  pdftoppm -r 50 -f "$1" -l "$1" test.pdf page > /dev/null 2>&1
  python3 "$PROJECT_ROOT/tests/pixel_probe.py" pixel "$(echo page-*.ppm)" "$2" "$3"
}

# Count pixels of a rendered page matching a color:
# page_color_count PAGE X0 Y0 X1 Y1 R G B
page_color_count() {
  local page="$1"
  shift
  pdftoppm -r 150 -f "$page" -l "$page" test.pdf zone > /dev/null 2>&1
  python3 "$PROJECT_ROOT/tests/pixel_probe.py" count "$(echo zone-*.ppm)" "$@"
}

# Assert an RGB triple is within tolerance of an expected color.
assert_color() {
  local actual="$1" er="$2" eg="$3" eb="$4"
  read -r ar ag ab <<< "$actual"
  awk -v ar="$ar" -v ag="$ag" -v ab="$ab" -v er="$er" -v eg="$eg" -v eb="$eb" '
    function abs(v) { return v < 0 ? -v : v }
    BEGIN { exit !(abs(ar-er) <= 12 && abs(ag-eg) <= 12 && abs(ab-eb) <= 12) }'
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

@test "content slides show the section name, presentation title and slide number" {
  run compile_fixture test_beamer_content
  [ "$status" -eq 0 ]
  pdftotext -f 2 -l 2 test.pdf page2.txt
  grep -q "Primera Seccion" page2.txt
  grep -q "Presentacion de prueba" page2.txt
  grep -q "2" page2.txt
}

@test "content slides carry a uired header band" {
  compile_fixture test_beamer_content
  run page_pixel 1 0.5 0.06
  [ "$status" -eq 0 ]
  # uired = #E4004F
  assert_color "$output" 228 0 79
}

@test "content slides carry a uigray footer band" {
  compile_fixture test_beamer_content
  run page_pixel 1 0.5 0.955
  [ "$status" -eq 0 ]
  # uigray = #BFBFBF
  assert_color "$output" 191 191 191
}

@test "frame titles are uired" {
  compile_fixture test_beamer_content
  # The frame title sits in the band of content just below the header, on the
  # left half of the slide; its glyphs must be drawn in uired.
  run page_color_count 1 0.05 0.14 0.60 0.26 228 0 79
  [ "$status" -eq 0 ]
  [ "$output" -gt 50 ]
}
