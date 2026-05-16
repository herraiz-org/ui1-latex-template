# Plan: Jurisprudencia Bibliography Support

## Phase 1: `@jurisprudencia` Driver, Citation Format, and Section in `ui1activity.cls`

### Task 1.1: Write Failing LaTeX Fixture — Jurisprudencia Entry Rendering
- [x] Sub-task: Create `tests/latex/test_jurisprudencia.tex` — a minimal document
      using `ui1activity` with one `@jurisprudencia` entry in a `.bib` file
- [x] Sub-task: Create `tests/latex/test_jurisprudencia.bib` with the STS 751/1984
      sample entry (all 8 fields populated)
- [x] Sub-task: Confirm fixture fails to compile (driver not yet defined)

### Task 1.2: Write Failing LaTeX Fixture — Empty Jurisprudencia Guard
- [x] Sub-task: Create `tests/latex/test_jurisprudencia_empty.tex` — a document
      with no `@jurisprudencia` entries; confirm no empty section is emitted
- [x] Sub-task: Confirm fixture produces wrong output or errors before implementation

### Task 1.3: Write Failing BATS Tests — Jurisprudencia Feature in `.cls`
- [x] Sub-task: Create `tests/shell/jurisprudencia.bats` with tests that:
      - Assert `ui1activity.cls` contains `DeclareBibliographyDriver{jurisprudencia}`
      - Assert `test_jurisprudencia.tex` compiles without errors under
        `pdflatex` + `biber`
      - Assert output PDF contains "ECLI:"
      - Assert output PDF contains "Jurisprudencia"
      - Assert inline citation renders as "(STS 751/1984)"
      - Assert Jurisprudencia section appears before Legislación in a document
        that has both entry types
- [x] Sub-task: Run `bash tests/run_tests.sh tests/shell/jurisprudencia.bats` —
      confirm tests fail (Red phase)

### Task 1.4: Implement `jurisprudencia` Driver in `ui1activity.cls`
- [x] Sub-task: Add `\DeclareFieldFormat` statements for `kind`, `court`,
      `shortcourt`, `number`, `chamber`, `date`, `ecli` fields scoped to
      `[jurisprudencia]`
- [x] Sub-task: Add `\DeclareBibliographyDriver{jurisprudencia}{...}` block
      rendering: `{kind} {court} {number} ({chamber}), de {date}. ECLI:{ecli} {url}`
- [x] Sub-task: Compile `test_jurisprudencia.tex` manually — confirm entry renders
      correctly

### Task 1.5: Implement Custom Inline Citation Format
- [x] Sub-task: Add a `\DeclareCiteCommand` (or extend `\parencite`) that checks
      `\ifentrytype{jurisprudencia}` and renders `({shortcourt} {number})`
      instead of the standard author-year format
- [x] Sub-task: Confirm inline citation in `test_jurisprudencia.tex` renders as
      `(STS 751/1984)`

### Task 1.6: Implement Section Ordering and Conditional Display
- [x] Sub-task: Update `\defbibfilter{notlegislation}` (or rename/replace it) so
      that the main bibliography excludes both `legislation` and `jurisprudencia`
      types
- [x] Sub-task: Update `\makebibliography` to print in order:
      1. `\printbibliography[type=jurisprudencia, heading=bibintoc,
         title={Jurisprudencia}]`
      2. `\printbibliography[type=legislation, heading=bibintoc,
         title={\ui@legistitle}]`
      3. `\printbibliography[filter=notlegislationorjuris, heading=bibintoc]`
- [x] Sub-task: Add BATS assertion that Jurisprudencia heading precedes
      Legislación in a combined fixture

### Task 1.7: Run Full Test Suite and Verify
- [x] Sub-task: Run `bash tests/run_tests.sh tests/shell/*.bats`
- [x] Sub-task: Confirm all tests pass with no regressions

- [x] Task: Conductor - User Manual Verification 'Phase 1' (Protocol in workflow.md) [checkpoint: 8bd4712]

---

## Phase 2: CLI Scaffold Update (`bin/new-activity`)

### Task 2.1: Write Failing BATS Test — Jurisprudencia Sample in `referencias.bib`
- [x] Sub-task: Add test to `tests/shell/jurisprudencia.bats` (or a new file) that:
      - Runs `new-activity` with required flags
      - Asserts `referencias.bib` contains `% @jurisprudencia{`
      - Asserts the commented entry contains `kind`, `court`, `shortcourt`,
        `number`, `chamber`, `date`, `ecli`, `url` fields
- [x] Sub-task: Run test — confirm it fails (Red phase)

### Task 2.2: Implement Commented Jurisprudencia Example in `bin/new-activity`
- [x] Sub-task: Locate the `referencias.bib` generation block in `bin/new-activity`
- [x] Sub-task: Append the commented-out `@jurisprudencia` example block after the
      existing `@legislation` example (see spec FR-7 for exact text)
- [x] Sub-task: Run the BATS test — confirm it passes (Green phase)

### Task 2.3: Run Full Test Suite and Verify No Regressions
- [x] Sub-task: Run `bash tests/run_tests.sh tests/shell/*.bats`
- [x] Sub-task: Confirm all tests pass

- [ ] Task: Conductor - User Manual Verification 'Phase 2' (Protocol in workflow.md)
