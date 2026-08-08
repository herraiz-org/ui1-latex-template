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

@test "both checkout steps use actions/checkout v6" {
  [ "$(grep -c 'uses: actions/checkout@v6' "$CI_WORKFLOW")" -eq 2 ]
}

@test "workflow does not use deprecated actions/checkout v4" {
  ! grep -q 'uses: actions/checkout@v4' "$CI_WORKFLOW"
}
