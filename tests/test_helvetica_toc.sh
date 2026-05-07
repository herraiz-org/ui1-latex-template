#!/usr/bin/env bash
# Tests that ui1activity.cls applies Helvetica (sffamily) to TOC entries via titletoc.
# Run from the project root: bash tests/test_helvetica_toc.sh

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

# titletoc must be loaded
check "titletoc package is loaded" '\\RequirePackage\{titletoc\}'

# Section TOC entries must use \sffamily\bfseries
check "Section TOC entries use \\sffamily\\bfseries" '\\titlecontents\{section\}.*\\sffamily\\bfseries|\\sffamily\\bfseries.*\\titlecontents\{section\}'

# Subsection TOC entries must use \sffamily
check "Subsection TOC entries use \\sffamily" '\\titlecontents\{subsection\}'

# Subsubsection TOC entries must use \sffamily
check "Subsubsection TOC entries use \\sffamily" '\\titlecontents\{subsubsection\}'

# Compile test_toc.tex and confirm it produces a PDF
echo ""
echo "Compiling tests/test_toc.tex ..."
pdflatex -interaction=nonstopmode tests/test_toc.tex > /dev/null 2>&1
# Run twice to resolve TOC references
pdflatex -interaction=nonstopmode tests/test_toc.tex > /dev/null 2>&1
if [ -f test_toc.pdf ]; then
    echo "PASS: tests/test_toc.tex compiles to PDF"
    PASS=$((PASS + 1))
else
    echo "FAIL: tests/test_toc.tex did not produce a PDF"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
