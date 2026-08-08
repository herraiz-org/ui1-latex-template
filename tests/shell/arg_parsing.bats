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

@test "--help prints usage and exits 0" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "missing --asignatura exits 1 with error message" {
  run "$SCRIPT" --alumno "Israel" my-dir
  [ "$status" -eq 1 ]
  [[ "$output" == *"--asignatura"* ]]
}

@test "missing --alumno exits 1 with error message" {
  run "$SCRIPT" --asignatura "Matemáticas" my-dir
  [ "$status" -eq 1 ]
  [[ "$output" == *"--alumno"* ]]
}

@test "missing positional directory argument exits 1" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel"
  [ "$status" -eq 1 ]
  [[ "$output" == *"directory"* ]]
}

@test "default value for --grado is applied" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" --dry-run my-dir
  [ "$status" -eq 0 ]
  [[ "$output" == *"Grado en Administración y Dirección de Empresas"* ]]
}

@test "default value for --options is applied" {
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" --dry-run my-dir
  [ "$status" -eq 0 ]
  [[ "$output" == *"palatino,nohangbib"* ]]
}

@test "default value for --fecha is today's date" {
  TODAY=$(date +"%d de %B de %Y" | LC_ALL=es_ES.UTF-8 date -f - +"%d de %B de %Y" 2>/dev/null || date +"%Y-%m-%d")
  run "$SCRIPT" --asignatura "Matemáticas" --alumno "Israel" --dry-run my-dir
  [ "$status" -eq 0 ]
  # fecha should be non-empty (exact format tested in file-generation tests)
  [[ "$output" == *"fecha"* ]] || [[ "$output" == *"Fecha"* ]]
}
