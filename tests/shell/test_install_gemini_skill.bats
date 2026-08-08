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

PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

setup() {
  FAKE_HOME=$(mktemp -d)
  mkdir -p "$FAKE_HOME/bin"
  touch "$FAKE_HOME/.zshrc"
  FAKE_GEMINI_SKILLS=$(mktemp -d)
  export FAKE_HOME FAKE_GEMINI_SKILLS
}

teardown() {
  rm -rf "$FAKE_HOME" "$FAKE_GEMINI_SKILLS"
}

_run_make_install() {
  make -C "$PROJECT_ROOT" install \
    HOME="$FAKE_HOME" \
    INSTALL_BIN="$FAKE_HOME/bin" \
    ZSHRC="$FAKE_HOME/.zshrc" \
    INSTALL_GEMINI_SKILLS="$FAKE_GEMINI_SKILLS"
}

_run_make_uninstall() {
  make -C "$PROJECT_ROOT" uninstall \
    HOME="$FAKE_HOME" \
    INSTALL_BIN="$FAKE_HOME/bin" \
    ZSHRC="$FAKE_HOME/.zshrc" \
    INSTALL_GEMINI_SKILLS="$FAKE_GEMINI_SKILLS"
}

@test "make install creates new-activity/SKILL.md under INSTALL_GEMINI_SKILLS" {
  run _run_make_install
  [ "$status" -eq 0 ]
  [ -L "$FAKE_GEMINI_SKILLS/new-activity" ]
  [ -f "$FAKE_GEMINI_SKILLS/new-activity/SKILL.md" ]
}

@test "make install copies correct content to SKILL.md" {
  run _run_make_install
  [ "$status" -eq 0 ]
  diff "$PROJECT_ROOT/skills/new-activity/SKILL.md" \
    "$FAKE_GEMINI_SKILLS/new-activity/SKILL.md"
}

@test "make uninstall removes new-activity directory from INSTALL_GEMINI_SKILLS" {
  _run_make_install
  [ -d "$FAKE_GEMINI_SKILLS/new-activity" ]
  run _run_make_uninstall
  [ "$status" -eq 0 ]
  [ ! -d "$FAKE_GEMINI_SKILLS/new-activity" ]
}

@test "make install succeeds when INSTALL_GEMINI_SKILLS directory does not pre-exist" {
  rm -rf "$FAKE_GEMINI_SKILLS"
  run _run_make_install
  [ "$status" -eq 0 ]
  [ -f "$FAKE_GEMINI_SKILLS/new-activity/SKILL.md" ]
}

@test "make install migrates a legacy copied Gemini skill" {
  mkdir -p "$FAKE_GEMINI_SKILLS/new-activity"
  cp "$PROJECT_ROOT/skills/new-activity/SKILL.md" \
    "$FAKE_GEMINI_SKILLS/new-activity/SKILL.md"

  run _run_make_install

  [ "$status" -eq 0 ]
  [ -L "$FAKE_GEMINI_SKILLS/new-activity" ]
  [ -f "$FAKE_GEMINI_SKILLS/new-activity/SKILL.md" ]
}
