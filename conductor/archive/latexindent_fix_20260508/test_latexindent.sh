#!/usr/bin/env bash
# Test: latexindent must not add extra tabs on continuation lines
# inside inline text commands (\textbf, \emph, \textit, \textsf, \texttt, \underline).
# Run from any directory; paths are resolved relative to this script.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SNIPPET="$SCRIPT_DIR/test_snippet.tex"
FORMATTED=$(latexindent "$SNIPPET" 2>/dev/null)

PASS=true

check_no_extra_tab() {
    local cmd="$1"
    # After a line containing the command, the next line must not start with a tab
    if echo "$FORMATTED" | grep -A1 "\\\\${cmd}{" | grep -qP '^\t'; then
        echo "FAIL: \\${cmd} continuation line has an extra tab"
        PASS=false
    else
        echo "PASS: \\${cmd} continuation line has no extra tab"
    fi
}

for cmd in textbf emph textit textsf texttt underline; do
    check_no_extra_tab "$cmd"
done

# Regression: \begin{itemize} \item lines should still be indented
if echo "$FORMATTED" | grep -qP '^\t\\item'; then
    echo "PASS: \\item inside itemize is still indented"
else
    echo "FAIL: \\item inside itemize lost its indentation (regression)"
    PASS=false
fi

if $PASS; then
    echo ""
    echo "All checks passed."
    exit 0
else
    echo ""
    echo "One or more checks failed."
    exit 1
fi
