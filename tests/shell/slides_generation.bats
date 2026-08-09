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

SCRIPT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/bin/new-slides"

setup() {
  TMPDIR=$(mktemp -d)
  export TMPDIR
}

teardown() {
  rm -rf "$TMPDIR"
}

@test "target directory is created" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" "$TMPDIR/my-slides"
  [ "$status" -eq 0 ]
  [ -d "$TMPDIR/my-slides" ]
}

@test "script aborts if target directory already exists" {
  mkdir -p "$TMPDIR/existing-dir"
  touch "$TMPDIR/existing-dir/keep-me"
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" "$TMPDIR/existing-dir"
  [ "$status" -eq 1 ]
  [[ "$output" == *"already exists"* ]]
  # The existing directory is left untouched.
  [ -f "$TMPDIR/existing-dir/keep-me" ]
  [ ! -f "$TMPDIR/existing-dir/existing-dir.tex" ]
}

@test ".tex file is named after the directory and loads the theme" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" "$TMPDIR/my-slides"
  [ "$status" -eq 0 ]
  TEX_COUNT=$(find "$TMPDIR/my-slides" -maxdepth 1 -name "*.tex" | wc -l)
  [ "$TEX_COUNT" -eq 1 ]
  [ -f "$TMPDIR/my-slides/my-slides.tex" ]
  grep -qF '\documentclass[aspectratio=169]{beamer}' "$TMPDIR/my-slides/my-slides.tex"
  grep -qF '\usetheme{ui1beamer}' "$TMPDIR/my-slides/my-slides.tex"
}

@test ".tex file carries the supplied metadata" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" \
    --asignatura "Matemáticas" --subtitulo "Unidad 1" --fecha "9 de agosto de 2026" \
    "$TMPDIR/my-slides"
  [ "$status" -eq 0 ]
  grep -qF '\title{Introducción}' "$TMPDIR/my-slides/my-slides.tex"
  grep -qF '\author{Israel}' "$TMPDIR/my-slides/my-slides.tex"
  grep -qF '\asignatura{Matemáticas}' "$TMPDIR/my-slides/my-slides.tex"
  grep -qF '\subtitle{Unidad 1}' "$TMPDIR/my-slides/my-slides.tex"
  grep -qF '\date{9 de agosto de 2026}' "$TMPDIR/my-slides/my-slides.tex"
}

@test ".tex file contains a title frame and a sample content frame" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" "$TMPDIR/my-slides"
  [ "$status" -eq 0 ]
  grep -qF '\titlepage' "$TMPDIR/my-slides/my-slides.tex"
  grep -qF '\section' "$TMPDIR/my-slides/my-slides.tex"
  grep -qF '\begin{frame}' "$TMPDIR/my-slides/my-slides.tex"
}

@test "generated Makefile contains pdf, clean and open targets" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" "$TMPDIR/my-slides"
  [ "$status" -eq 0 ]
  [ -f "$TMPDIR/my-slides/Makefile" ]
  grep -q "^pdf" "$TMPDIR/my-slides/Makefile"
  grep -q "^clean" "$TMPDIR/my-slides/Makefile"
  grep -q "^open" "$TMPDIR/my-slides/Makefile"
}

@test "no imgs symlink is created: images resolve through the texmf tree" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" "$TMPDIR/my-slides"
  [ "$status" -eq 0 ]
  [ ! -e "$TMPDIR/my-slides/imgs" ]
}

@test "the scaffolded presentation compiles" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" "$TMPDIR/my-slides"
  [ "$status" -eq 0 ]
  # Stand in for `make install` by placing the theme and images next to the
  # generated document.
  ln -s "$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/beamerthemeui1beamer.sty" \
    "$TMPDIR/my-slides/beamerthemeui1beamer.sty"
  ln -s "$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/imgs" "$TMPDIR/my-slides/imgs"
  cd "$TMPDIR/my-slides"
  run pdflatex -interaction=nonstopmode -halt-on-error my-slides.tex
  [ "$status" -eq 0 ]
  [ -f my-slides.pdf ]
}
