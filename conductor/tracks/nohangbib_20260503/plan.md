# Implementation Plan: Configure Bibliography Hanging Indent

## Phase 1: Setup and Testing
- [x] Task: Create a test LaTeX file `tests/test_bib_nohang.tex` using the `nohangbib` option and `referencias.bib`. 8601c20
- [x] Task: Update the `Makefile` to include `test_bib_nohang` in the `test` build target. fb3a5d8
- [ ] Task: Compile the test suite and verify that `test_bib_nohang.tex` fails to apply the expected flush-left formatting (this is the TDD "Red Phase").
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Setup and Testing' (Protocol in workflow.md)

## Phase 2: Implementation
- [ ] Task: Modify `ui1activity.cls` to declare a new option `nohangbib`.
- [ ] Task: Process the `nohangbib` option in `ui1activity.cls` using `ifthen` or similar boolean logic.
- [ ] Task: Add configuration for `biblatex` to set `\bibhang` to `0pt` when the `nohangbib` option is enabled.
- [ ] Task: Re-run the test suite and ensure `test_bib_nohang.tex` compiles with flush-left references (the TDD "Green Phase").
- [ ] Task: Verify that existing tests (e.g., `tests/test_bib.tex`) continue to pass with default hanging indent.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implementation' (Protocol in workflow.md)