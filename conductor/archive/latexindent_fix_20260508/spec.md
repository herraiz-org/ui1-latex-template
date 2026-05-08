# Spec: Fix latexindent Extra Tab on Multiline Command Arguments

## Overview

When apheleia formats a LaTeX file using `latexindent`, continuation lines inside
multi-argument commands such as `\textbf{...}` and `\emph{...}` receive an
unwanted extra tab character. This causes inconsistent indentation compared to
surrounding lines and makes the formatted output harder to read.

## Reproduction

**Before formatting:**
```latex
Some text with \textbf{a long argument that
needs to wrap onto a second line}.
```

**After formatting (broken):**
```latex
Some text with \textbf{a long argument that
	needs to wrap onto a second line}.
```

**Expected after formatting:**
```latex
Some text with \textbf{a long argument that
needs to wrap onto a second line}.
```

## Root Cause

`latexindent` treats the argument block of commands like `\textbf` and `\emph`
as a new indentation scope and increases the indent level for continuation lines.

## Functional Requirements

1. The user-global `latexindent` configuration must instruct `latexindent` to
   apply no additional indentation inside the argument blocks of inline text
   commands (at minimum: `\textbf`, `\emph`, `\textit`, `\textsf`, `\texttt`,
   `\underline`).
2. The fix must not affect block-level environments or commands where indentation
   is intentional (e.g., `\begin{...}`, `\section{...}`).
3. The configuration must be placed at the user-global level so it applies to
   all LaTeX projects on this machine.

## Acceptance Criteria

- [ ] A multiline `\textbf{...}` argument is not given an extra tab on its
      continuation lines after `latexindent` / apheleia formatting.
- [ ] Same holds for `\emph`, `\textit`, `\textsf`, `\texttt`, `\underline`.
- [ ] Block environments and section commands retain their normal indentation
      behavior.
- [ ] The fix is stored in the user-global `latexindent` config
      (`~/.indentconfig.yaml` or equivalent).

## Out of Scope

- Changes to `ui1activity.cls` or any project file.
- Fixing apheleia itself or other formatters.
- Changing indentation style (tabs vs spaces).
