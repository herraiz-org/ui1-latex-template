#!/usr/bin/env bats

SCRIPT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/bin/new-activity"
ROOT_MAKEFILE="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/Makefile"

setup() {
  TMPDIR=$(mktemp -d)
  export TMPDIR
}

teardown() {
  rm -rf "$TMPDIR"
}

@test "generated Makefile open target depends on pdf" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" "$TMPDIR/my-dir"
  [ "$status" -eq 0 ]
  [ -f "$TMPDIR/my-dir/Makefile" ]
  grep -q "^open: pdf" "$TMPDIR/my-dir/Makefile"
}

