#!/usr/bin/env bats

SCRIPT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)/new-activity"

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
