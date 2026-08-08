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
  export FAKE_HOME
  # Stub zshrc
  touch "$FAKE_HOME/.zshrc"
}

teardown() {
  rm -rf "$FAKE_HOME"
}

_run_make_install() {
  make -C "$PROJECT_ROOT" install \
    HOME="$FAKE_HOME" \
    INSTALL_BIN="$FAKE_HOME/bin" \
    ZSHRC="$FAKE_HOME/.zshrc"
}

_run_make_uninstall() {
  make -C "$PROJECT_ROOT" uninstall \
    HOME="$FAKE_HOME" \
    INSTALL_BIN="$FAKE_HOME/bin" \
    ZSHRC="$FAKE_HOME/.zshrc"
}

@test "make install copies new-activity to ~/bin/ and makes it executable" {
  run _run_make_install
  [ "$status" -eq 0 ]
  [ -f "$FAKE_HOME/bin/new-activity" ]
  [ -x "$FAKE_HOME/bin/new-activity" ]
}

@test "make install appends PATH export to ~/.zshrc when not present" {
  run _run_make_install
  [ "$status" -eq 0 ]
  grep -q 'export PATH.*HOME.*bin' "$FAKE_HOME/.zshrc"
}

@test "make install is idempotent (running twice does not duplicate PATH line)" {
  _run_make_install
  _run_make_install
  COUNT=$(grep -c 'export PATH.*HOME.*bin' "$FAKE_HOME/.zshrc" || true)
  [ "$COUNT" -eq 1 ]
}

@test "make uninstall removes new-activity from ~/bin/" {
  _run_make_install
  run _run_make_uninstall
  [ "$status" -eq 0 ]
  [ ! -f "$FAKE_HOME/bin/new-activity" ]
}

@test "make install copies skills/new-activity/SKILL.md to ~/.claude/skills/new-activity/SKILL.md" {
  run _run_make_install
  [ "$status" -eq 0 ]
  [ -f "$FAKE_HOME/.agents/skills/new-activity/SKILL.md" ]
  [ -L "$FAKE_HOME/.claude/skills/new-activity" ]
  [ -f "$FAKE_HOME/.claude/skills/new-activity/SKILL.md" ]
  diff "$PROJECT_ROOT/skills/new-activity/SKILL.md" \
    "$FAKE_HOME/.agents/skills/new-activity/SKILL.md"
}

@test "make uninstall removes new-activity skill directory from ~/.claude/skills/" {
  _run_make_install
  [ -f "$FAKE_HOME/.claude/skills/new-activity/SKILL.md" ]
  run _run_make_uninstall
  [ "$status" -eq 0 ]
  [ ! -d "$FAKE_HOME/.claude/skills/new-activity" ]
  [ ! -d "$FAKE_HOME/.agents/skills/new-activity" ]
}

@test "make install creates compatibility links for Antigravity" {
  run _run_make_install
  [ "$status" -eq 0 ]
  [ -L "$FAKE_HOME/.gemini/config/skills/new-activity" ]
  [ -L "$FAKE_HOME/.gemini/antigravity-cli/skills/new-activity" ]
  [ -f "$FAKE_HOME/.gemini/config/skills/new-activity/SKILL.md" ]
  [ -f "$FAKE_HOME/.gemini/antigravity-cli/skills/new-activity/SKILL.md" ]
}

@test "make install supports canonical and compatibility directory overrides" {
  local canonical="$FAKE_HOME/custom-agent-skills"
  local compat_one="$FAKE_HOME/compat-one"
  local compat_two="$FAKE_HOME/compat-two"

  run make -C "$PROJECT_ROOT" install \
    HOME="$FAKE_HOME" \
    INSTALL_BIN="$FAKE_HOME/bin" \
    ZSHRC="$FAKE_HOME/.zshrc" \
    INSTALL_AGENT_SKILLS="$canonical" \
    SKILL_COMPAT_DIRS="$compat_one $compat_two"

  [ "$status" -eq 0 ]
  [ -f "$canonical/new-activity/SKILL.md" ]
  [ "$(readlink "$compat_one/new-activity")" = "$canonical/new-activity" ]
  [ "$(readlink "$compat_two/new-activity")" = "$canonical/new-activity" ]
}

@test "make install refuses to replace a non-managed skill directory" {
  mkdir -p "$FAKE_HOME/.claude/skills/new-activity"
  touch "$FAKE_HOME/.claude/skills/new-activity/custom-file"

  run _run_make_install

  [ "$status" -ne 0 ]
  [ -f "$FAKE_HOME/.claude/skills/new-activity/custom-file" ]
}

@test "make uninstall preserves unrelated skills" {
  mkdir -p "$FAKE_HOME/.agents/skills/other-skill"
  touch "$FAKE_HOME/.agents/skills/other-skill/SKILL.md"
  _run_make_install

  run _run_make_uninstall

  [ "$status" -eq 0 ]
  [ -f "$FAKE_HOME/.agents/skills/other-skill/SKILL.md" ]
}

@test "make uninstall preserves a non-managed same-name skill" {
  mkdir -p "$FAKE_HOME/custom-compat/new-activity"
  touch "$FAKE_HOME/custom-compat/new-activity/SKILL.md"
  touch "$FAKE_HOME/custom-compat/new-activity/custom-file"

  run make -C "$PROJECT_ROOT" uninstall \
    HOME="$FAKE_HOME" \
    INSTALL_BIN="$FAKE_HOME/bin" \
    INSTALL_AGENT_SKILLS="$FAKE_HOME/canonical" \
    SKILL_COMPAT_DIRS="$FAKE_HOME/custom-compat"

  [ "$status" -eq 0 ]
  [ -f "$FAKE_HOME/custom-compat/new-activity/SKILL.md" ]
  [ -f "$FAKE_HOME/custom-compat/new-activity/custom-file" ]
}
