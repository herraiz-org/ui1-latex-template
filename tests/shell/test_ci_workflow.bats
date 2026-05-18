#!/usr/bin/env bats

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
CI_WORKFLOW="$REPO_ROOT/.github/workflows/ci.yml"

@test "ci.yml workflow file exists" {
  [ -f "$CI_WORKFLOW" ]
}

@test "workflow triggers on push events" {
  grep -q "push" "$CI_WORKFLOW"
}

@test "workflow triggers on pull_request events" {
  grep -q "pull_request" "$CI_WORKFLOW"
}

@test "workflow includes shellcheck step" {
  grep -q "shellcheck" "$CI_WORKFLOW"
}

@test "workflow includes BATS test step" {
  grep -q "run_tests.sh" "$CI_WORKFLOW"
}

@test "workflow includes LaTeX make test step" {
  grep -q "make test" "$CI_WORKFLOW"
}
