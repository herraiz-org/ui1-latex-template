#!/usr/bin/env bash
# Tests the Makefile install and uninstall targets by mocking TEXMF_DIR.
# Run from the project root: bash tests/test_install.sh

set -euo pipefail
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'
PASS=0
FAIL=0
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MOCK_TEXMF="$(mktemp -d)"
TEXMF_TARGET="${MOCK_TEXMF}/tex/latex/ui1_template"

cleanup() {
    rm -rf "$MOCK_TEXMF"
}
trap cleanup EXIT

check() {
    local desc="$1"
    local condition="$2"
    if eval "$condition"; then
        echo -e "${GREEN}PASS${RESET}: $desc"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${RESET}: $desc"
        FAIL=$((FAIL + 1))
    fi
}

cd "$PROJECT_ROOT"

# --- Test: make install creates symlinks ---
echo "Running: make install TEXMF_DIR=${TEXMF_TARGET}"
make install TEXMF_DIR="${TEXMF_TARGET}" > /dev/null 2>&1 || true

check "install creates target directory" "[ -d '${TEXMF_TARGET}' ]"
check "install creates symlink for ui1activity.cls" "[ -L '${TEXMF_TARGET}/ui1activity.cls' ]"
check "symlink for ui1activity.cls points to correct file" \
    "[ \"$(readlink -f "${TEXMF_TARGET}/ui1activity.cls" 2>/dev/null)\" = '${PROJECT_ROOT}/ui1activity.cls' ]"
check "install creates symlink for imgs directory" "[ -L '${TEXMF_TARGET}/imgs' ]"
check "symlink for imgs points to correct directory" \
    "[ \"$(readlink -f "${TEXMF_TARGET}/imgs" 2>/dev/null)\" = '${PROJECT_ROOT}/imgs' ]"

# --- Test: make install is idempotent (second run must not fail) ---
echo ""
echo "Running second make install to test idempotency..."
make install TEXMF_DIR="${TEXMF_TARGET}" > /dev/null 2>&1 || true
check "install is idempotent (second run succeeds)" "[ -L '${TEXMF_TARGET}/ui1activity.cls' ]"

# --- Test: make uninstall removes symlinks ---
echo ""
echo "Running: make uninstall TEXMF_DIR=${TEXMF_TARGET}"
make uninstall TEXMF_DIR="${TEXMF_TARGET}" > /dev/null 2>&1 || true

check "uninstall removes symlink for ui1activity.cls" "[ ! -e '${TEXMF_TARGET}/ui1activity.cls' ]"
check "uninstall removes symlink for imgs directory" "[ ! -e '${TEXMF_TARGET}/imgs' ]"

echo ""
echo -e "Results: ${GREEN}$PASS passed${RESET}, ${RED}$FAIL failed${RESET}"
[ "$FAIL" -eq 0 ]
