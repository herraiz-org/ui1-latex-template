#!/usr/bin/env bash
# Tests that the cover table in ui1activity.cls uses \sffamily for:
#   - the red header cell (grado + curso académico)
#   - the field labels in gray cells (Asignatura:, Unidad didáctica:, Alumno:, Fecha:)
# Run from the project root: bash tests/test_helvetica_cover.sh

set -euo pipefail
PASS=0
FAIL=0
CLS="ui1activity.cls"

check() {
    local desc="$1"
    local pattern="$2"
    if grep -qP "$pattern" "$CLS"; then
        echo "PASS: $desc"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $desc"
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
    echo "PASS: test_cover.tex compiles to PDF"
    PASS=$((PASS + 1))
else
    echo "FAIL: test_cover.tex did not produce a PDF"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
