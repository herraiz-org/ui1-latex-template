#!/usr/bin/env bats

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
