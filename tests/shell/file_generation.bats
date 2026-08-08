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

SCRIPT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/bin/new-activity"

setup() {
  TMPDIR=$(mktemp -d)
  export TMPDIR
}

teardown() {
  rm -rf "$TMPDIR"
}

@test "target directory is created" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  [ -d "$TMPDIR/my-dir" ]
}

@test "script aborts if target directory already exists" {
  mkdir -p "$TMPDIR/existing-dir"
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/existing-dir"
  [ "$status" -eq 1 ]
  [[ "$output" == *"already exists"* ]]
}

@test ".tex file is created with correct metadata fields" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  # Exactly one .tex file exists
  TEX_COUNT=$(find "$TMPDIR/my-dir" -maxdepth 1 -name "*.tex" | wc -l)
  [ "$TEX_COUNT" -eq 1 ]
  TEX_FILE=$(find "$TMPDIR/my-dir" -maxdepth 1 -name "*.tex")
  grep -q "asignatura" "$TEX_FILE"
  grep -q "alumno" "$TEX_FILE"
  grep -q "Matemáticas" "$TEX_FILE"
  grep -q "Israel" "$TEX_FILE"
}

@test "referencias.bib is created (empty)" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  [ -f "$TMPDIR/my-dir/referencias.bib" ]
}

@test "generated Makefile contains pdf target" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  [ -f "$TMPDIR/my-dir/Makefile" ]
  grep -q "^pdf" "$TMPDIR/my-dir/Makefile"
}

@test "generated Makefile contains clean target" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  grep -q "^clean" "$TMPDIR/my-dir/Makefile"
}

@test "generated Makefile contains open target" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  grep -q "^open" "$TMPDIR/my-dir/Makefile"
}

@test "referencias.bib contains commented-out @legislation example" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  grep -q "% @legislation{" "$TMPDIR/my-dir/referencias.bib"
}

@test "referencias.bib legislation example contains required fields" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  grep -q "title" "$TMPDIR/my-dir/referencias.bib"
  grep -q "number" "$TMPDIR/my-dir/referencias.bib"
  grep -q "eid" "$TMPDIR/my-dir/referencias.bib"
  grep -q "year" "$TMPDIR/my-dir/referencias.bib"
}
