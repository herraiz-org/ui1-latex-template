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

@test "--help prints usage and exits 0" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "missing --titulo exits 1 with error message" {
  run "$SCRIPT" --autor "Israel" my-slides
  [ "$status" -eq 1 ]
  [[ "$output" == *"--titulo"* ]]
}

@test "missing --autor exits 1 with error message" {
  run "$SCRIPT" --titulo "Introducción" my-slides
  [ "$status" -eq 1 ]
  [[ "$output" == *"--autor"* ]]
}

@test "missing positional directory argument exits 1" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel"
  [ "$status" -eq 1 ]
  [[ "$output" == *"directory"* ]]
}

@test "unknown flag exits 1" {
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" --unknown x my-slides
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unknown flag"* ]]
}

@test "--dry-run reports the resolved values without creating anything" {
  TMP_DIR=$(mktemp -d)
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" --dry-run "$TMP_DIR/my-slides"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Introducción"* ]]
  [[ "$output" == *"Israel"* ]]
  [ ! -d "$TMP_DIR/my-slides" ]
  rm -rf "$TMP_DIR"
}

@test "default value for --fecha is applied" {
  TMP_DIR=$(mktemp -d)
  run "$SCRIPT" --titulo "Introducción" --autor "Israel" --dry-run "$TMP_DIR/my-slides"
  [ "$status" -eq 0 ]
  [[ "$output" == *"fecha"* ]]
  # The resolved date line must not be empty.
  echo "$output" | grep -E "fecha: +[^ ]"
  rm -rf "$TMP_DIR"
}
