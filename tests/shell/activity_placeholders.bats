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

# The generated activity ships commented-out examples of the document-level
# packages a student is likely to need (listings, figures, branded tables,
# math). These tests check that the examples are present, that they stay inert
# until uncommented, and that they actually compile once uncommented.

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
SCRIPT="$REPO_ROOT/bin/new-activity"

setup() {
  WORK_DIR=$(mktemp -d)
  "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$WORK_DIR/actividad" > /dev/null
  TEX="$WORK_DIR/actividad/actividad.tex"
  BIB="$WORK_DIR/actividad/referencias.bib"
}

teardown() {
  rm -rf "$WORK_DIR"
}

# Strip the comment prefix from every line inside the example markers, leaving
# the marker lines themselves commented.
uncomment_examples() {
  sed -i '/EJEMPLOS \/ EXAMPLES/,/EJEMPLOS \/ EXAMPLES/{/EJEMPLOS \/ EXAMPLES/!s/^% \{0,1\}//}' "$1"
}

@test "generated .tex marks the example blocks with BEGIN/END delimiters" {
  [ "$(grep -c '^% --- BEGIN EJEMPLOS / EXAMPLES' "$TEX")" -eq 2 ]
  [ "$(grep -c '^% --- END EJEMPLOS / EXAMPLES' "$TEX")" -eq 2 ]
}

@test "generated .tex offers a commented listings preamble" {
  grep -q '^% \\usepackage{listings}' "$TEX"
  grep -q '^% \\lstset{' "$TEX"
}

@test "generated .tex offers a commented figure example" {
  grep -q '^% \\begin{figure}' "$TEX"
  grep -q '^% *\\includegraphics' "$TEX"
}

@test "generated .tex offers a commented branded table example" {
  grep -q '^% \\begin{table}' "$TEX"
  grep -q 'tabularx' "$TEX"
  grep -q 'uired' "$TEX"
}

@test "generated .tex offers a commented equation example" {
  grep -q '^% \\begin{equation}' "$TEX"
}

@test "generated .tex offers a commented lstlisting example" {
  grep -q '^% \\begin{lstlisting}' "$TEX"
}

@test "generated .tex cites the commented bibliography entries from referencias.bib" {
  grep -q 'lott1987' "$TEX"
  grep -q 'sts751_1984' "$TEX"
  grep -q '% @legislation{lott1987' "$BIB"
  grep -q '% @jurisprudencia{sts751_1984' "$BIB"
}

@test "the examples are inert: the generated activity compiles untouched" {
  ln -s "$REPO_ROOT/ui1activity.cls" "$WORK_DIR/actividad/ui1activity.cls"
  ln -s "$REPO_ROOT/imgs" "$WORK_DIR/actividad/imgs"
  cd "$WORK_DIR/actividad"
  run pdflatex -interaction=nonstopmode -halt-on-error actividad.tex
  [ "$status" -eq 0 ]
  [ -f actividad.pdf ]
}

@test "the examples compile once uncommented" {
  ln -s "$REPO_ROOT/ui1activity.cls" "$WORK_DIR/actividad/ui1activity.cls"
  ln -s "$REPO_ROOT/imgs" "$WORK_DIR/actividad/imgs"
  # The figure example points at a file the student supplies.
  cp "$REPO_ROOT/imgs/interior.png" "$WORK_DIR/actividad/mi-figura.png"
  uncomment_examples "$TEX"
  sed -i 's/^% \{0,1\}//' "$BIB"
  cd "$WORK_DIR/actividad"
  run pdflatex -interaction=nonstopmode -halt-on-error actividad.tex
  [ "$status" -eq 0 ]
  [ -f actividad.pdf ]
}

@test "uncommented examples resolve their citations" {
  ln -s "$REPO_ROOT/ui1activity.cls" "$WORK_DIR/actividad/ui1activity.cls"
  ln -s "$REPO_ROOT/imgs" "$WORK_DIR/actividad/imgs"
  cp "$REPO_ROOT/imgs/interior.png" "$WORK_DIR/actividad/mi-figura.png"
  uncomment_examples "$TEX"
  sed -i 's/^% \{0,1\}//' "$BIB"
  cd "$WORK_DIR/actividad"
  pdflatex -interaction=nonstopmode actividad.tex > /dev/null 2>&1
  biber actividad > /dev/null 2>&1
  pdflatex -interaction=nonstopmode actividad.tex > /dev/null 2>&1
  pdflatex -interaction=nonstopmode actividad.tex > /dev/null 2>&1
  # Both custom bibliography sections must appear, and no citation may dangle.
  run grep -c "Citation.*undefined" actividad.log
  [ "$output" -eq 0 ]
  pdftotext actividad.pdf - | grep -q "Jurisprudencia"
  pdftotext actividad.pdf - | grep -q "Legislación"
}
