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

@test "root Makefile contains open target depending on \$(MAIN).pdf" {
  grep -q "^open:.*\$(MAIN)\.pdf" "$ROOT_MAKEFILE"
}

@test "root Makefile open target uses xdg-open" {
  grep -q "xdg-open.*\$(MAIN)\.pdf" "$ROOT_MAKEFILE"
}

@test "root Makefile declares open as PHONY" {
  grep -qE "\.PHONY.*open" "$ROOT_MAKEFILE"
}

