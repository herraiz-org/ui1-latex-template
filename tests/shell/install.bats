#!/usr/bin/env bats

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
