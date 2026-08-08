#!/usr/bin/env bash
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

# Tests that the cover table in ui1activity.cls uses \sffamily for:
#   - the red header cell (grado + curso académico)
#   - the field labels in gray cells (Asignatura:, Unidad didáctica:, Alumno:, Fecha:)
# Run from the project root: bash tests/test_helvetica_cover.sh

set -euo pipefail
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'
PASS=0
FAIL=0
CLS="ui1activity.cls"

check() {
    local desc="$1"
    local pattern="$2"
    if grep -qP "$pattern" "$CLS"; then
        echo -e "${GREEN}PASS${RESET}: $desc"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}FAIL${RESET}: $desc"
        echo "      Expected pattern not found: $pattern"
        FAIL=$((FAIL + 1))
    fi
}

# Header cell must declare \sffamily before \@grado
check "Header cell uses \\sffamily" '\\sffamily.*\\bfseries.*\\fontsize|\\sffamily.*\\fontsize'

# Each label must be wrapped in \textsf{...}
check "Asignatura label uses \\textsf" '\\textsf\{.*Asignatura'
check "Unidad didáctica label uses \\textsf" '\\textsf\{.*Unidad'
check "Alumno label uses \\textsf" '\\textsf\{.*Alumno'
check "Fecha label uses \\textsf" '\\textsf\{.*Fecha'

# Compile test_cover.tex and confirm it produces a PDF
echo ""
echo "Compiling tests/test_cover.tex ..."
pdflatex -interaction=nonstopmode tests/latex/test_cover.tex > /dev/null 2>&1
if [ -f test_cover.pdf ]; then
    echo -e "${GREEN}PASS${RESET}: test_cover.tex compiles to PDF"
    PASS=$((PASS + 1))
else
    echo -e "${RED}FAIL${RESET}: test_cover.tex did not produce a PDF"
    FAIL=$((FAIL + 1))
fi

echo ""
echo -e "Results: ${GREEN}$PASS passed${RESET}, ${RED}$FAIL failed${RESET}"
[ "$FAIL" -eq 0 ]
