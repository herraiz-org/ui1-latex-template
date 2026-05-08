# Plan: Fix latexindent Extra Tab on Multiline Command Arguments

## Phase 1: Diagnose and Prepare Test Case [checkpoint: b6153d1]

- [x] Task: Write Failing Test — create a minimal `.tex` snippet containing
      multiline `\textbf{...}`, `\emph{...}`, `\textit{...}`, `\textsf{...}`,
      `\texttt{...}`, and `\underline{...}` arguments (8d5e017)
- [x] Task: Run `latexindent` on the test snippet and confirm that continuation
      lines receive an extra tab (Red phase — expected to fail) (f78c3a4)
- [x] Task: Locate the user-global `latexindent` config entry point
      (`~/.indentconfig.yaml`) and identify the active settings file, or
      determine that a new one must be created — neither exists; new files required
- [x] Task: Conductor - User Manual Verification 'Phase 1: Diagnose and Prepare Test Case' (Protocol in workflow.md) (b6153d1)

## Phase 2: Implement Fix

- [ ] Task: Add `noAdditionalIndent` rules for `\textbf`, `\emph`, `\textit`,
      `\textsf`, `\texttt`, and `\underline` to the user-global latexindent
      settings YAML file
- [ ] Task: Run `latexindent` on the test snippet and confirm that no extra tabs
      appear on continuation lines (Green phase — expected to pass)
- [ ] Task: Verify that block environments and section commands still indent
      correctly (regression check)
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implement Fix' (Protocol in workflow.md)
