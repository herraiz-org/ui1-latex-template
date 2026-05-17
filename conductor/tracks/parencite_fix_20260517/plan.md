# Plan: Bug Fix — Autor ausente en citas normales

## Phase 1: Diagnose & Write Failing Test

- [x] Task: Analyze `\DeclareCiteCommand{\parencite}` in `ui1activity.cls` (lines 108–115)
  - [x] Sub-task: Confirm that `\usebibmacro{cite}` in the else branch omits the author
        in APA-style parencite (expected: `(Apellido, año)`, actual: `(año)`).
  - [x] Sub-task: Confirm that empty-section warnings come from unconditional
        `\printbibliography[type=jurisprudencia]` and `\printbibliography[type=legislation]`
        calls when no entries of those types are cited.
- [x] Task: Create LaTeX fixture `tests/latex/test_normal_citation.tex` — a minimal
      document that cites a `@book` entry with `\autocite[pp.~102-103]{key}`.
- [x] Task: Create `tests/latex/test_normal_citation.bib` with a single `@book` entry.
- [x] Task: Write BATS test in `tests/shell/normal_citation.bats`
  - [x] Sub-task: Test that the compiled PDF text contains the author surname in the
        in-text citation (e.g., via `pdftotext` grep).
  - [x] Sub-task: Test that the compilation log contains no warnings about empty
        jurisprudencia or legislation sections.
- [x] Task: Run the new BATS test and confirm it FAILS (Red phase). [d18e1b5]
- [x] Task: Conductor - User Manual Verification 'Phase 1: Diagnose & Write Failing Test' (Protocol in workflow.md)

## Phase 2: Fix & Green Phase

- [~] Task: Fix the `\parencite` override in `ui1activity.cls`
  - [ ] Sub-task: Replace `\usebibmacro{cite}` in the else branch with the correct
        APA cite macros (e.g., `\usebibmacro{cite:author}` +
        `\usebibmacro{cite:year+labelyear}`) or remove the override and use
        `\DeclareMultiCiteCommand` / `\AtEveryBibitem` to handle jurisprudencia
        inline-cite formatting without replacing the full `\parencite` command.
- [ ] Task: Fix empty-section warnings
  - [ ] Sub-task: Wrap `\printbibliography[type=jurisprudencia]` and
        `\printbibliography[type=legislation]` in conditional checks so they
        only render when at least one matching entry is cited.
- [ ] Task: Run the new BATS test and confirm it PASSES (Green phase).
- [ ] Task: Run full BATS test suite (`bash tests/run_tests.sh tests/shell/*.bats`)
      and confirm no regressions.
- [ ] Task: Commit the fix with message
      `fix(cls): Restore APA author display in parencite for standard entries`.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Fix & Green Phase' (Protocol in workflow.md)
