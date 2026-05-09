#!/usr/bin/env bats

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
